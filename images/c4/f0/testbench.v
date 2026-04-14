`timescale 1ns/1ps

module flag_register_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg CLR;
    reg IN_FLAG;
    reg LD;
    reg SET;
    wire OUT_FLAG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flag_register dut (
        .CLK(CLK),
        .CLR(CLR),
        .IN_FLAG(IN_FLAG),
        .LD(LD),
        .SET(SET),
        .OUT_FLAG(OUT_FLAG)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR = 1;
            SET = 0;
            LD = 0;
            IN_FLAG = 0;
            @(posedge CLK);
            #1;
            CLR = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Loading 1 via IN_FLAG", test_num);
            reset_dut();
            @(negedge CLK);
            LD = 1;
            IN_FLAG = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Loading 0 via IN_FLAG", test_num);
            reset_dut();

            @(negedge CLK);
            SET = 1;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            SET = 0;
            LD = 1;
            IN_FLAG = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing SET input", test_num);
            reset_dut();
            @(negedge CLK);
            SET = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing CLR input", test_num);
            reset_dut();

            @(negedge CLK);
            SET = 1;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            SET = 0;
            CLR = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Testing Data Hold (No control signals)", test_num);
            reset_dut();

            @(negedge CLK);
            LD = 1;
            IN_FLAG = 1;
            @(posedge CLK);
            #1;

            @(negedge CLK);
            LD = 0;
            SET = 0;
            CLR = 0;
            IN_FLAG = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (CLR vs SET)", test_num);
            reset_dut();
            @(negedge CLK);
            CLR = 1;
            SET = 1;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Priority Check (SET vs LD)", test_num);
            reset_dut();
            @(negedge CLK);
            SET = 1;
            LD = 1;
            IN_FLAG = 0;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load ignore when LD=0", test_num);
            reset_dut();
            @(negedge CLK);
            LD = 0;
            IN_FLAG = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flag_register Testbench");
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
        input expected_OUT_FLAG;
        begin
            if (expected_OUT_FLAG === (expected_OUT_FLAG ^ OUT_FLAG ^ expected_OUT_FLAG)) begin
                $display("PASS");
                $display("  Outputs: OUT_FLAG=%b",
                         OUT_FLAG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT_FLAG=%b",
                         expected_OUT_FLAG);
                $display("  Got:      OUT_FLAG=%b",
                         OUT_FLAG);
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
        $dumpvars(0,CLK, CLR, IN_FLAG, LD, SET, OUT_FLAG);
    end

endmodule
