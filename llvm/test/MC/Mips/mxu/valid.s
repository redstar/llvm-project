# RUN: llvm-mc  %s -triple=mips-unknown-linux -show-encoding -mattr=+mxu  \
# RUN:   | FileCheck %s

# CHECK: s32m2i $xr1, $4                      # encoding: [0x70,0x04,0x00,0x6e]
# CHECK: s32i2m $xr1, $4                      # encoding: [0x70,0x04,0x00,0x6f]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 0, 0  # encoding: [0x70,0x10,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 0, 1  # encoding: [0x70,0x50,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 0, 2  # encoding: [0x70,0x90,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 0, 3  # encoding: [0x70,0xd0,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 1, 0  # encoding: [0x71,0x10,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 1, 1  # encoding: [0x71,0x50,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 1, 2  # encoding: [0x71,0x90,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 1, 3  # encoding: [0x71,0xd0,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 2, 0  # encoding: [0x72,0x10,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 2, 1  # encoding: [0x72,0x50,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 2, 2  # encoding: [0x72,0x90,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 2, 3  # encoding: [0x72,0xd0,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 3, 0  # encoding: [0x73,0x10,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 3, 1  # encoding: [0x73,0x50,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 3, 2  # encoding: [0x73,0x90,0xc8,0x4a]
# CHECK: d16mac $xr1, $xr2, $xr3, $xr4, 3, 3  # encoding: [0x73,0xd0,0xc8,0x4a]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 0, 0 # encoding: [0x70,0x10,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 0, 1 # encoding: [0x70,0x50,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 0, 2 # encoding: [0x70,0x90,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 0, 3 # encoding: [0x70,0xd0,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 1, 0 # encoding: [0x71,0x10,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 1, 1 # encoding: [0x71,0x50,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 1, 2 # encoding: [0x71,0x90,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 1, 3 # encoding: [0x71,0xd0,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 2, 0 # encoding: [0x72,0x10,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 2, 1 # encoding: [0x72,0x50,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 2, 2 # encoding: [0x72,0x90,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 2, 3 # encoding: [0x72,0xd0,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 3, 0 # encoding: [0x73,0x10,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 3, 1 # encoding: [0x73,0x50,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 3, 2 # encoding: [0x73,0x90,0xc8,0x4b]
# CHECK: d16macf $xr1, $xr2, $xr3, $xr4, 3, 3 # encoding: [0x73,0xd0,0xc8,0x4b]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 0, 0 # encoding: [0x70,0x10,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 0, 1 # encoding: [0x70,0x50,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 0, 2 # encoding: [0x70,0x90,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 0, 3 # encoding: [0x70,0xd0,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 1, 0 # encoding: [0x71,0x10,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 1, 1 # encoding: [0x71,0x50,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 1, 2 # encoding: [0x71,0x90,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 1, 3 # encoding: [0x71,0xd0,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 2, 0 # encoding: [0x72,0x10,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 2, 1 # encoding: [0x72,0x50,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 2, 2 # encoding: [0x72,0x90,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 2, 3 # encoding: [0x72,0xd0,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 3, 0 # encoding: [0x73,0x10,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 3, 1 # encoding: [0x73,0x50,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 3, 2 # encoding: [0x73,0x90,0xc8,0x4c]
# CHECK: d16madl $xr1, $xr2, $xr3, $xr4, 3, 3 # encoding: [0x73,0xd0,0xc8,0x4c]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 0, 0  # encoding: [0x70,0x10,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 0, 1  # encoding: [0x70,0x50,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 0, 2  # encoding: [0x70,0x90,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 0, 3  # encoding: [0x70,0xd0,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 1, 0  # encoding: [0x71,0x10,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 1, 1  # encoding: [0x71,0x50,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 1, 2  # encoding: [0x71,0x90,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 1, 3  # encoding: [0x71,0xd0,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 2, 0  # encoding: [0x72,0x10,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 2, 1  # encoding: [0x72,0x50,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 2, 2  # encoding: [0x72,0x90,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 2, 3  # encoding: [0x72,0xd0,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 3, 0  # encoding: [0x73,0x10,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 3, 1  # encoding: [0x73,0x50,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 3, 2  # encoding: [0x73,0x90,0xc8,0x4e]
# CHECK: q16add $xr1, $xr2, $xr3, $xr4, 3, 3  # encoding: [0x73,0xd0,0xc8,0x4e]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 0, 0 # encoding: [0x70,0x10,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 0, 1 # encoding: [0x70,0x50,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 0, 2 # encoding: [0x70,0x90,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 0, 3 # encoding: [0x70,0xd0,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 1, 0 # encoding: [0x71,0x10,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 1, 1 # encoding: [0x71,0x50,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 1, 2 # encoding: [0x71,0x90,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 1, 3 # encoding: [0x71,0xd0,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 2, 0 # encoding: [0x72,0x10,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 2, 1 # encoding: [0x72,0x50,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 2, 2 # encoding: [0x72,0x90,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 2, 3 # encoding: [0x72,0xd0,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 3, 0 # encoding: [0x73,0x10,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 3, 1 # encoding: [0x73,0x50,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 3, 2 # encoding: [0x73,0x90,0xc8,0x4f]
# CHECK: d16mace $xr1, $xr2, $xr3, $xr4, 3, 3 # encoding: [0x73,0xd0,0xc8,0x4f]

# CHECK: d16mul $xr1, $xr2, $xr3, $xr4, 0     # encoding: [0x70,0x10,0xc8,0x48]
# CHECK: q8mul   $xr1, $xr2, $xr3, $xr4       # encoding: [0x70,0x10,0xc8,0x78]
# CHECK: q8mulsu $xr1, $xr2, $xr3, $xr4       # encoding: [0x70,0x90,0xc8,0x78]
# CHECK: q8movz  $xr1, $xr2, $xr3             # encoding: [0x70,0x00,0xc8,0x79]
# CHECK: q8movn  $xr1, $xr2, $xr3             # encoding: [0x70,0x04,0xc8,0x79]
# CHECK: d16movz $xr1, $xr2, $xr3             # encoding: [0x70,0x08,0xc8,0x79]
# CHECK: d16movn $xr1, $xr2, $xr3             # encoding: [0x70,0x0c,0xc8,0x79]
# CHECK: s32movz $xr1, $xr2, $xr3             # encoding: [0x70,0x10,0xc8,0x79]
# CHECK: s32movn $xr1, $xr2, $xr3             # encoding: [0x70,0x14,0xc8,0x79]
# CHECK: q8mac $xr1, $xr2, $xr3, $xr4, 0      # encoding: [0x70,0x10,0xc8,0x7a]
# CHECK: q8mac $xr1, $xr2, $xr3, $xr4, 2      # encoding: [0x72,0x10,0xc8,0x7a]
# CHECK: q8mac $xr1, $xr2, $xr3, $xr4, 1      # encoding: [0x71,0x10,0xc8,0x7a]
# CHECK: q8mac $xr1, $xr2, $xr3, $xr4, 3      # encoding: [0x73,0x10,0xc8,0x7a]
# CHECK: q16scop $xr1, $xr2, $xr3, $xr4       # encoding: [0x70,0x10,0xc8,0x7b]
# CHECK: s32sfl $xr1, $xr2, $xr3, $xr4, 0     # encoding: [0x70,0x10,0xc8,0x7d]
# CHECK: s32sfl $xr1, $xr2, $xr3, $xr4, 1     # encoding: [0x71,0x10,0xc8,0x7d]
# CHECK: s32sfl $xr1, $xr2, $xr3, $xr4, 2     # encoding: [0x72,0x10,0xc8,0x7d]
# CHECK: s32sfl $xr1, $xr2, $xr3, $xr4, 3     # encoding: [0x73,0x10,0xc8,0x7d]
# CHECK: q8sad $xr1, $xr2, $xr3, $xr4         # encoding: [0x70,0x10,0xc8,0x7e]
# CHECK: q16acc $xr1, $xr2, $xr3, $xr4, 0     # encoding: [0x70,0x10,0xc8,0x5b]
# CHECK: q16acc $xr1, $xr2, $xr3, $xr4, 2     # encoding: [0x72,0x10,0xc8,0x5b]
# CHECK: q16acc $xr1, $xr2, $xr3, $xr4, 1     # encoding: [0x71,0x10,0xc8,0x5b]
# CHECK: q16acc $xr1, $xr2, $xr3, $xr4, 3     # encoding: [0x73,0x10,0xc8,0x5b]
# CHECK: q16accm $xr1, $xr2, $xr3, $xr4, 0    # encoding: [0x70,0x50,0xc8,0x5b]
# CHECK: q16accm $xr1, $xr2, $xr3, $xr4, 2    # encoding: [0x72,0x50,0xc8,0x5b]
# CHECK: q16accm $xr1, $xr2, $xr3, $xr4, 1    # encoding: [0x71,0x50,0xc8,0x5b]
# CHECK: q16accm $xr1, $xr2, $xr3, $xr4, 3    # encoding: [0x73,0x50,0xc8,0x5b]
# CHECK: d16asum $xr1, $xr2, $xr3, $xr4, 0    # encoding: [0x70,0x90,0xc8,0x5b]
# CHECK: d16asum $xr1, $xr2, $xr3, $xr4, 2    # encoding: [0x72,0x90,0xc8,0x5b]
# CHECK: d16asum $xr1, $xr2, $xr3, $xr4, 1    # encoding: [0x71,0x90,0xc8,0x5b]
# CHECK: d16asum $xr1, $xr2, $xr3, $xr4, 3    # encoding: [0x73,0x90,0xc8,0x5b]
# CHECK: q8adde  $xr1, $xr2, $xr3, $xr4, 0    # encoding: [0x70,0x10,0xc8,0x5c]
# CHECK: q8adde  $xr1, $xr2, $xr3, $xr4, 2    # encoding: [0x72,0x10,0xc8,0x5c]
# CHECK: q8adde  $xr1, $xr2, $xr3, $xr4, 1    # encoding: [0x71,0x10,0xc8,0x5c]
# CHECK: q8adde  $xr1, $xr2, $xr3, $xr4, 3    # encoding: [0x73,0x10,0xc8,0x5c]
# CHECK: q8acce  $xr1, $xr2, $xr3, $xr4, 0    # encoding: [0x70,0x10,0xc8,0x5d]
# CHECK: q8acce  $xr1, $xr2, $xr3, $xr4, 2    # encoding: [0x72,0x10,0xc8,0x5d]
# CHECK: q8acce  $xr1, $xr2, $xr3, $xr4, 1    # encoding: [0x71,0x10,0xc8,0x5d]
# CHECK: q8acce  $xr1, $xr2, $xr3, $xr4, 3    # encoding: [0x73,0x10,0xc8,0x5d]
# CHECK: s32cps $xr1, $xr2, $xr3              # encoding: [0x70,0x00,0xc8,0x47]
# CHECK: d16cps $xr1, $xr2, $xr3              # encoding: [0x70,0x08,0xc8,0x47]
# CHECK: q8abd $xr1, $xr2, $xr3               # encoding: [0x70,0x10,0xc8,0x47]
# CHECK: q16sat $xr1, $xr2, $xr3              # encoding: [0x70,0x18,0xc8,0x47]
# CHECK: s32slt $xr1, $xr2, $xr3              # encoding: [0x70,0x00,0xc8,0x46]
# CHECK: d16slt $xr1, $xr2, $xr3              # encoding: [0x70,0x04,0xc8,0x46]
# CHECK: d16avg $xr1, $xr2, $xr3              # encoding: [0x70,0x08,0xc8,0x46]
# CHECK: d16avgr $xr1, $xr2, $xr3             # encoding: [0x70,0x0c,0xc8,0x46]
# CHECK: q8avg $xr1, $xr2, $xr3               # encoding: [0x70,0x10,0xc8,0x46]
# CHECK: q8avgr $xr1, $xr2, $xr3              # encoding: [0x70,0x14,0xc8,0x46]
# CHECK: s32max $xr1, $xr2, $xr3              # encoding: [0x70,0x00,0xc8,0x43]
# CHECK: s32min $xr1, $xr2, $xr3              # encoding: [0x70,0x04,0xc8,0x43]
# CHECK: d16max $xr1, $xr2, $xr3              # encoding: [0x70,0x08,0xc8,0x43]
# CHECK: d16min $xr1, $xr2, $xr3              # encoding: [0x70,0x0c,0xc8,0x43]
# CHECK: q8max $xr1, $xr2, $xr3               # encoding: [0x70,0x10,0xc8,0x43]
# CHECK: q8min $xr1, $xr2, $xr3               # encoding: [0x70,0x14,0xc8,0x43]
# CHECK: q8slt $xr1, $xr2, $xr3               # encoding: [0x70,0x18,0xc8,0x43]
# CHECK: q8sltu $xr1, $xr2, $xr3              # encoding: [0x70,0x1c,0xc8,0x43]
# CHECK: s32nor $xr1, $xr2, $xr3              # encoding: [0x70,0x10,0xc8,0x67]
# CHECK: s32and $xr1, $xr2, $xr3              # encoding: [0x70,0x14,0xc8,0x67]
# CHECK: s32or $xr1, $xr2, $xr3               # encoding: [0x70,0x18,0xc8,0x67]
# CHECK: s32xor $xr1, $xr2, $xr3              # encoding: [0x70,0x1c,0xc8,0x67]
# CHECK: s32ldd $xr1, $zero, 2044             # encoding: [0x70,0x07,0xfc,0x50]
# CHECK: s32ldd $xr1, $zero, -2048            # encoding: [0x70,0x08,0x00,0x50]
# CHECK: s32lddr $xr1, $zero, 2044            # encoding: [0x70,0x17,0xfc,0x50]
# CHECK: s32lddr $xr1, $zero, -2048           # encoding: [0x70,0x18,0x00,0x50]

foo:
  s32m2i  $xr1, $a0
  s32i2m  $xr1, $a0
  d16mac  $xr1, $xr2, $xr3, $xr4, aa, ww
  d16mac  $xr1, $xr2, $xr3, $xr4, aa, lw
  d16mac  $xr1, $xr2, $xr3, $xr4, aa, hw
  d16mac  $xr1, $xr2, $xr3, $xr4, aa, xw
  d16mac  $xr1, $xr2, $xr3, $xr4, as, ww
  d16mac  $xr1, $xr2, $xr3, $xr4, as, lw
  d16mac  $xr1, $xr2, $xr3, $xr4, as, hw
  d16mac  $xr1, $xr2, $xr3, $xr4, as, xw
  d16mac  $xr1, $xr2, $xr3, $xr4, sa, ww
  d16mac  $xr1, $xr2, $xr3, $xr4, sa, lw
  d16mac  $xr1, $xr2, $xr3, $xr4, sa, hw
  d16mac  $xr1, $xr2, $xr3, $xr4, sa, xw
  d16mac  $xr1, $xr2, $xr3, $xr4, ss, ww
  d16mac  $xr1, $xr2, $xr3, $xr4, ss, lw
  d16mac  $xr1, $xr2, $xr3, $xr4, ss, hw
  d16mac  $xr1, $xr2, $xr3, $xr4, ss, xw
  d16macf $xr1, $xr2, $xr3, $xr4, aa, ww
  d16macf $xr1, $xr2, $xr3, $xr4, aa, lw
  d16macf $xr1, $xr2, $xr3, $xr4, aa, hw
  d16macf $xr1, $xr2, $xr3, $xr4, aa, xw
  d16macf $xr1, $xr2, $xr3, $xr4, as, ww
  d16macf $xr1, $xr2, $xr3, $xr4, as, lw
  d16macf $xr1, $xr2, $xr3, $xr4, as, hw
  d16macf $xr1, $xr2, $xr3, $xr4, as, xw
  d16macf $xr1, $xr2, $xr3, $xr4, sa, ww
  d16macf $xr1, $xr2, $xr3, $xr4, sa, lw
  d16macf $xr1, $xr2, $xr3, $xr4, sa, hw
  d16macf $xr1, $xr2, $xr3, $xr4, sa, xw
  d16macf $xr1, $xr2, $xr3, $xr4, ss, ww
  d16macf $xr1, $xr2, $xr3, $xr4, ss, lw
  d16macf $xr1, $xr2, $xr3, $xr4, ss, hw
  d16macf $xr1, $xr2, $xr3, $xr4, ss, xw
  d16madl $xr1, $xr2, $xr3, $xr4, aa, ww
  d16madl $xr1, $xr2, $xr3, $xr4, aa, lw
  d16madl $xr1, $xr2, $xr3, $xr4, aa, hw
  d16madl $xr1, $xr2, $xr3, $xr4, aa, xw
  d16madl $xr1, $xr2, $xr3, $xr4, as, ww
  d16madl $xr1, $xr2, $xr3, $xr4, as, lw
  d16madl $xr1, $xr2, $xr3, $xr4, as, hw
  d16madl $xr1, $xr2, $xr3, $xr4, as, xw
  d16madl $xr1, $xr2, $xr3, $xr4, sa, ww
  d16madl $xr1, $xr2, $xr3, $xr4, sa, lw
  d16madl $xr1, $xr2, $xr3, $xr4, sa, hw
  d16madl $xr1, $xr2, $xr3, $xr4, sa, xw
  d16madl $xr1, $xr2, $xr3, $xr4, ss, ww
  d16madl $xr1, $xr2, $xr3, $xr4, ss, lw
  d16madl $xr1, $xr2, $xr3, $xr4, ss, hw
  d16madl $xr1, $xr2, $xr3, $xr4, ss, xw
  q16add  $xr1, $xr2, $xr3, $xr4, aa, ww
  q16add  $xr1, $xr2, $xr3, $xr4, aa, lw
  q16add  $xr1, $xr2, $xr3, $xr4, aa, hw
  q16add  $xr1, $xr2, $xr3, $xr4, aa, xw
  q16add  $xr1, $xr2, $xr3, $xr4, as, ww
  q16add  $xr1, $xr2, $xr3, $xr4, as, lw
  q16add  $xr1, $xr2, $xr3, $xr4, as, hw
  q16add  $xr1, $xr2, $xr3, $xr4, as, xw
  q16add  $xr1, $xr2, $xr3, $xr4, sa, ww
  q16add  $xr1, $xr2, $xr3, $xr4, sa, lw
  q16add  $xr1, $xr2, $xr3, $xr4, sa, hw
  q16add  $xr1, $xr2, $xr3, $xr4, sa, xw
  q16add  $xr1, $xr2, $xr3, $xr4, ss, ww
  q16add  $xr1, $xr2, $xr3, $xr4, ss, lw
  q16add  $xr1, $xr2, $xr3, $xr4, ss, hw
  q16add  $xr1, $xr2, $xr3, $xr4, ss, xw
  d16mace $xr1, $xr2, $xr3, $xr4, aa, ww
  d16mace $xr1, $xr2, $xr3, $xr4, aa, lw
  d16mace $xr1, $xr2, $xr3, $xr4, aa, hw
  d16mace $xr1, $xr2, $xr3, $xr4, aa, xw
  d16mace $xr1, $xr2, $xr3, $xr4, as, ww
  d16mace $xr1, $xr2, $xr3, $xr4, as, lw
  d16mace $xr1, $xr2, $xr3, $xr4, as, hw
  d16mace $xr1, $xr2, $xr3, $xr4, as, xw
  d16mace $xr1, $xr2, $xr3, $xr4, sa, ww
  d16mace $xr1, $xr2, $xr3, $xr4, sa, lw
  d16mace $xr1, $xr2, $xr3, $xr4, sa, hw
  d16mace $xr1, $xr2, $xr3, $xr4, sa, xw
  d16mace $xr1, $xr2, $xr3, $xr4, ss, ww
  d16mace $xr1, $xr2, $xr3, $xr4, ss, lw
  d16mace $xr1, $xr2, $xr3, $xr4, ss, hw
  d16mace $xr1, $xr2, $xr3, $xr4, ss, xw
  d16mul  $xr1, $xr2, $xr3, $xr4, ww
  q8mul   $xr1, $xr2, $xr3, $xr4
  q8mulsu $xr1, $xr2, $xr3, $xr4
  q8movz  $xr1, $xr2, $xr3
  q8movn  $xr1, $xr2, $xr3
  d16movz $xr1, $xr2, $xr3
  d16movn $xr1, $xr2, $xr3
  s32movz $xr1, $xr2, $xr3
  s32movn $xr1, $xr2, $xr3
  q8mac   $xr1, $xr2, $xr3, $xr4, aa
  q8mac   $xr1, $xr2, $xr3, $xr4, sa
  q8mac   $xr1, $xr2, $xr3, $xr4, as
  q8mac   $xr1, $xr2, $xr3, $xr4, ss
  q16scop $xr1, $xr2, $xr3, $xr4
  s32sfl  $xr1, $xr2, $xr3, $xr4, ptn0
  s32sfl  $xr1, $xr2, $xr3, $xr4, ptn1
  s32sfl  $xr1, $xr2, $xr3, $xr4, ptn2
  s32sfl  $xr1, $xr2, $xr3, $xr4, ptn3
  q8sad   $xr1, $xr2, $xr3, $xr4
  q16acc  $xr1, $xr2, $xr3, $xr4, aa
  q16acc  $xr1, $xr2, $xr3, $xr4, sa
  q16acc  $xr1, $xr2, $xr3, $xr4, as
  q16acc  $xr1, $xr2, $xr3, $xr4, ss
  q16accm $xr1, $xr2, $xr3, $xr4, aa
  q16accm $xr1, $xr2, $xr3, $xr4, sa
  q16accm $xr1, $xr2, $xr3, $xr4, as
  q16accm $xr1, $xr2, $xr3, $xr4, ss
  d16asum $xr1, $xr2, $xr3, $xr4, aa
  d16asum $xr1, $xr2, $xr3, $xr4, sa
  d16asum $xr1, $xr2, $xr3, $xr4, as
  d16asum $xr1, $xr2, $xr3, $xr4, ss
  q8adde  $xr1, $xr2, $xr3, $xr4, aa
  q8adde  $xr1, $xr2, $xr3, $xr4, sa
  q8adde  $xr1, $xr2, $xr3, $xr4, as
  q8adde  $xr1, $xr2, $xr3, $xr4, ss
  q8acce  $xr1, $xr2, $xr3, $xr4, aa
  q8acce  $xr1, $xr2, $xr3, $xr4, sa
  q8acce  $xr1, $xr2, $xr3, $xr4, as
  q8acce  $xr1, $xr2, $xr3, $xr4, ss
  s32cps  $xr1, $xr2, $xr3
  d16cps  $xr1, $xr2, $xr3
  q8abd   $xr1, $xr2, $xr3
  q16sat  $xr1, $xr2, $xr3
  s32slt  $xr1, $xr2, $xr3
  d16slt  $xr1, $xr2, $xr3
  d16avg  $xr1, $xr2, $xr3
  d16avgr $xr1, $xr2, $xr3
  q8avg   $xr1, $xr2, $xr3
  q8avgr  $xr1, $xr2, $xr3
  s32max  $xr1, $xr2, $xr3
  s32min  $xr1, $xr2, $xr3
  d16max  $xr1, $xr2, $xr3
  d16min  $xr1, $xr2, $xr3
  q8max   $xr1, $xr2, $xr3
  q8min   $xr1, $xr2, $xr3
  q8slt   $xr1, $xr2, $xr3
  q8sltu  $xr1, $xr2, $xr3
  s32nor  $xr1, $xr2, $xr3
  s32and  $xr1, $xr2, $xr3
  s32or   $xr1, $xr2, $xr3
  s32xor  $xr1, $xr2, $xr3
  s32ldd  $xr1, $zero, 2044
  s32ldd  $xr1, $zero, -2048
  s32lddr $xr1, $zero, 2044
  s32lddr $xr1, $zero, -2048