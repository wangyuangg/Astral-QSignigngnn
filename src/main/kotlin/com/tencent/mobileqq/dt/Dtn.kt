package com.tencent.mobileqq.dt

import com.github.unidbg.linux.android.dvm.DvmObject
import moe.fuqiuluo.unidbg.QSecVM

object Dtn {
    fun initContext(vm: QSecVM, context: DvmObject<*>) {
        runCatching {
            // 9.2.70+ 使用 initNativeContext(Context, String)
            vm.newInstance("com/tencent/mobileqq/dt/Dtn", unique = true)
                .callJniMethod(vm.emulator, "initNativeContext(Landroid/content/Context;Ljava/lang/String;)V",
                    context, "/data/user/0/${vm.envData.packageName}/files/5463306EE50FE3AA")
        }.onFailure {
            // 旧版本兼容
            vm.newInstance("com/tencent/mobileqq/dt/Dtn", unique = true)
                .callJniMethod(vm.emulator, "initContext(Landroid/content/Context;)V", context)
        }
    }

    fun initLog(vm: QSecVM, context: DvmObject<*>, logger: DvmObject<*>) {
        runCatching {
            // 9.2.70+ 使用 initNativeLog(Context, IFEKitLog)
            vm.newInstance("com/tencent/mobileqq/dt/Dtn", unique = true)
                .callJniMethod(vm.emulator, "initNativeLog(Landroid/content/Context;Lcom/tencent/mobileqq/fe/IFEKitLog;)V", context, logger)
        }.onFailure {
            // 旧版本兼容
            vm.newInstance("com/tencent/mobileqq/dt/Dtn", unique = true)
                .callJniMethod(vm.emulator, "initLog(Lcom/tencent/mobileqq/fe/IFEKitLog;)V", logger)
        }
    }

    fun initUin(vm: QSecVM, uin: String) {
        vm.newInstance("com/tencent/mobileqq/dt/Dtn", unique = true)
            .callJniMethod(vm.emulator, "initUin(Ljava/lang/String;)V", uin)
    }
}