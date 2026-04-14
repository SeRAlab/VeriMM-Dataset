`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] D;
    reg LOAD;
    reg SHL;
    reg SHR;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .D(D),
        .LOAD(LOAD),
        .SHL(SHL),
        .SHR(SHR),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        LOAD = 0;
        forever #5 LOAD = ~LOAD;
    end

        task reset_dut;

        begin
            D = 4'b0000;
            LOAD = 1;
            SHL = 0;
            SHR = 0;
            #10;
            LOAD = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 4'b1010", test_num);
            reset_dut();
            D = 4'b1010;
            LOAD = 1; SHL = 0; SHR = 0;
            #10;
            LOAD = 0;
            #10;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 4'b0101", test_num);
            reset_dut();
            D = 4'b0101;
            LOAD = 1; SHL = 0; SHR = 0;
            #10;
            LOAD = 0;
            #10;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 0001 and Shift Left", test_num);
            reset_dut();

            D = 4'b0001; LOAD = 1; SHL = 0; SHR = 0; #10;

            LOAD = 0; SHL = 1; SHR = 0; #10;
            SHL = 0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 1000 and Shift Right", test_num);
            reset_dut();

            D = 4'b1000; LOAD = 1; SHL = 0; SHR = 0; #10;

            LOAD = 0; SHL = 0; SHR = 1; #10;
            SHR = 0;
            #1;

            check_outputs(4'b0100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 1111 and Shift Left (bit insertion check)", test_num);
            reset_dut();
            D = 4'b1111; LOAD = 1; #10;
            LOAD = 0; SHL = 1; #10;
            SHL = 0;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Load 1111 and Shift Right (bit insertion check)", test_num);
            reset_dut();
            D = 4'b1111; LOAD = 1; #10;
            LOAD = 0; SHR = 1; #10;
            SHR = 0;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Shift Lefts", test_num);
            reset_dut();
            D = 4'b0001; LOAD = 1; #10;
            LOAD = 0; SHL = 1; #30;
            SHL = 0;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Shift Rights", test_num);
            reset_dut();
            D = 4'b1000; LOAD = 1; #10;
            LOAD = 0; SHR = 1; #30;
            SHR = 0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left until zero", test_num);
            reset_dut();
            D = 4'b1000; LOAD = 1; #10;
            LOAD = 0; SHL = 1; #10;
            SHL = 0;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right until zero", test_num);
            reset_dut();
            D = 4'b0001; LOAD = 1; #10;
            LOAD = 0; SHR = 1; #10;
            SHR = 0;
            #1;

            check_outputs(4'b0000);
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
        testcase009();
        testcase010();
        
        
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,D, LOAD, SHL, SHR, Q);
    end

endmodule
