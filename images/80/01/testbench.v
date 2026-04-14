`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg ee;
    reg ep;
    reg hold;
    reg reset;
    wire veto;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .ee(ee),
        .ep(ep),
        .hold(hold),
        .reset(reset),
        .veto(veto)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            ee = 0;
            ep = 0;
            hold = 0;
            @(posedge clock);
            #1 reset = 0;
            @(posedge clock);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            ee = 0;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: NORMAL to HOLDING and back to NORMAL", test_num);
            reset_dut();


            hold = 1;
            @(posedge clock);


            #1 hold = 0;
            @(posedge clock);

            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reach ONLY_EE state with ee=0 (Veto High)", test_num);
            reset_dut();


            hold = 1;
            @(posedge clock);


            #1 ep = 1;
            @(posedge clock);


            #1 ee = 0;
            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reach ONLY_EE state with ee=1 (Veto Low)", test_num);
            reset_dut();


            hold = 1;
            @(posedge clock);


            #1 ep = 1;
            @(posedge clock);


            #1 ee = 1;
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: ONLY_EE transition back to NORMAL", test_num);
            reset_dut();


            hold = 1; @(posedge clock);
            #1 ep = 1; @(posedge clock);


            #1 hold = 0; ee = 1;
            @(posedge clock);


            #1 ee = 0;
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stay in HOLDING if ep=0", test_num);
            reset_dut();


            hold = 1;
            @(posedge clock);


            #1 ep = 0;
            repeat(2) @(posedge clock);


            #1 ee = 0;
            #1 #1;
 check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Stay in ONLY_EE while hold=1", test_num);
            reset_dut();


            hold = 1; @(posedge clock);
            #1 ep = 1; @(posedge clock);


            #1 ee = 1; @(posedge clock);
            #1 ee = 0; @(posedge clock);


            #1 #1;
 check_outputs(1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: ONLY_EE persists if hold=0 and ee=0", test_num);
            reset_dut();


            hold = 1; @(posedge clock);
            #1 ep = 1; @(posedge clock);


            #1 hold = 0; ee = 0;
            @(posedge clock);



            #1 #1;
 check_outputs(1);
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
        testcase008();
        
        
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
        input expected_veto;
        begin
            if (expected_veto === (expected_veto ^ veto ^ expected_veto)) begin
                $display("PASS");
                $display("  Outputs: veto=%b",
                         veto);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: veto=%b",
                         expected_veto);
                $display("  Got:      veto=%b",
                         veto);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clock, ee, ep, hold, reset, veto);
    end

endmodule
