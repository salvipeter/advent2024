      program adv09

      implicit none

      integer, dimension(*), parameter :: data = [
C     DATA PLACEHOLDER
     $     ]
      integer, parameter :: n = size(data), last = n - 1 + mod(n, 2)
      integer, dimension(n) :: used
      integer :: id, pos, i, j, ki, kj, sum

      i = 2                     ! index of space in array
      pos = data(1)             ! position
      j = last                  ! index of the file to move
      id = j / 2                ! ID of the file to move
      ki = 0                    ! space already used
      kj = 0                    ! chunks already moved
      sum = 0                   ! checksum

      do
         if (data(i) == ki) then
C     Search for the next available space
            ki = 0
            do
               if (i + 1 == j) then
                  exit
               end if
C     Also updating the checksum
               sum = sum + (2 * pos + data(i+1) - 1) * data(i+1) * i / 4
               pos = pos + data(i+1)
               i = i + 2
               if (data(i) /= 0) then
                  exit
               end if
            end do
         end if
         if (data(j) == kj) then
C     Go on to the next file to move
            kj = 0
            j = j - 2
            id = id - 1
         end if
         if (j < i) then
            exit
         end if
         sum = sum + pos * id
         pos = pos + 1
         ki = ki + 1
         kj = kj + 1
      end do

      print *, sum

C     Part 2

      j = last                  ! index of the file to move
      id = j / 2                ! ID of the file to move
      used(:) = 0               ! space used in each space block
      sum = 0                   ! checksum

      do
C     Find space for the current file
         i = 2
         pos = data(1)
         do
            if (i > j) then
C     No suitable space to the left
               pos = pos - data(j)
               sum = sum + (2 * pos + data(j) - 1) * data(j) / 2 * id
               exit
            end if
            if (data(i) - used(i) >= data(j)) then
C     Free space found
               pos = pos + used(i)
               sum = sum + (2 * pos + data(j) - 1) * data(j) / 2 * id
               used(i) = used(i) + data(j)
               exit
            end if
            pos = pos + data(i) + data(i+1)
            i = i + 2
         end do
         j = j - 2
         id = id - 1
         if (id == 0) then
            exit
         end if
      end do

      print *, sum

      end program adv09
