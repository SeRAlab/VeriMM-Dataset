`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable_ac97;
    reg enable_aceusb;
    reg enable_dmx;
    reg enable_ethernet;
    reg enable_fmlmeter;
    reg enable_ir;
    reg enable_memorycard;
    reg enable_memtest;
    reg enable_midi;
    reg enable_pfpu;
    reg enable_ps2keyboard;
    reg enable_ps2mouse;
    reg enable_tmu;
    reg enable_usb;
    reg enable_videoin;
    wire [31:0] capabilities;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable_ac97(enable_ac97),
        .enable_aceusb(enable_aceusb),
        .enable_dmx(enable_dmx),
        .enable_ethernet(enable_ethernet),
        .enable_fmlmeter(enable_fmlmeter),
        .enable_ir(enable_ir),
        .enable_memorycard(enable_memorycard),
        .enable_memtest(enable_memtest),
        .enable_midi(enable_midi),
        .enable_pfpu(enable_pfpu),
        .enable_ps2keyboard(enable_ps2keyboard),
        .enable_ps2mouse(enable_ps2mouse),
        .enable_tmu(enable_tmu),
        .enable_usb(enable_usb),
        .enable_videoin(enable_videoin),
        .capabilities(capabilities)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All inputs disabled", test_num);
        enable_memorycard = 0; enable_ac97 = 0; enable_pfpu = 0; enable_tmu = 0;
        enable_ethernet = 0; enable_fmlmeter = 0; enable_videoin = 0; enable_midi = 0;
        enable_dmx = 0; enable_ir = 0; enable_usb = 0; enable_memtest = 0;
        enable_aceusb = 0; enable_ps2keyboard = 0; enable_ps2mouse = 0;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: All inputs enabled", test_num);
        enable_memorycard = 1; enable_ac97 = 1; enable_pfpu = 1; enable_tmu = 1;
        enable_ethernet = 1; enable_fmlmeter = 1; enable_videoin = 1; enable_midi = 1;
        enable_dmx = 1; enable_ir = 1; enable_usb = 1; enable_memtest = 1;
        enable_aceusb = 1; enable_ps2keyboard = 1; enable_ps2mouse = 1;
        #1;

        check_outputs(32'h00007FFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Only MSB input (MemoryCard)", test_num);
        enable_memorycard = 1; enable_ac97 = 0; enable_pfpu = 0; enable_tmu = 0;
        enable_ethernet = 0; enable_fmlmeter = 0; enable_videoin = 0; enable_midi = 0;
        enable_dmx = 0; enable_ir = 0; enable_usb = 0; enable_memtest = 0;
        enable_aceusb = 0; enable_ps2keyboard = 0; enable_ps2mouse = 0;
        #1;

        check_outputs(32'h00004000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Only LSB input (PS2 Mouse)", test_num);
        enable_memorycard = 0; enable_ac97 = 0; enable_pfpu = 0; enable_tmu = 0;
        enable_ethernet = 0; enable_fmlmeter = 0; enable_videoin = 0; enable_midi = 0;
        enable_dmx = 0; enable_ir = 0; enable_usb = 0; enable_memtest = 0;
        enable_aceusb = 0; enable_ps2keyboard = 0; enable_ps2mouse = 1;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Middle input (MIDI - bit 7)", test_num);
        enable_memorycard = 0; enable_ac97 = 0; enable_pfpu = 0; enable_tmu = 0;
        enable_ethernet = 0; enable_fmlmeter = 0; enable_videoin = 0; enable_midi = 1;
        enable_dmx = 0; enable_ir = 0; enable_usb = 0; enable_memtest = 0;
        enable_aceusb = 0; enable_ps2keyboard = 0; enable_ps2mouse = 0;
        #1;

        check_outputs(32'h00000080);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Pattern 101010101010101 (0x5555)", test_num);
        enable_memorycard = 1; enable_ac97 = 0; enable_pfpu = 1; enable_tmu = 0;
        enable_ethernet = 1; enable_fmlmeter = 0; enable_videoin = 1; enable_midi = 0;
        enable_dmx = 1; enable_ir = 0; enable_usb = 1; enable_memtest = 0;
        enable_aceusb = 1; enable_ps2keyboard = 0; enable_ps2mouse = 1;
        #1;

        check_outputs(32'h00005555);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Pattern 010101010101010 (0x2AAA)", test_num);
        enable_memorycard = 0; enable_ac97 = 1; enable_pfpu = 0; enable_tmu = 1;
        enable_ethernet = 0; enable_fmlmeter = 1; enable_videoin = 0; enable_midi = 1;
        enable_dmx = 0; enable_ir = 1; enable_usb = 0; enable_memtest = 1;
        enable_aceusb = 0; enable_ps2keyboard = 1; enable_ps2mouse = 0;
        #1;

        check_outputs(32'h00002AAA);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [31:0] expected_capabilities;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_capabilities === (expected_capabilities ^ capabilities ^ expected_capabilities)) begin
                $display("PASS");
                $display("  Outputs: capabilities=%h",
                         capabilities);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: capabilities=%h",
                         expected_capabilities);
                $display("  Got:      capabilities=%h",
                         capabilities);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

endmodule
