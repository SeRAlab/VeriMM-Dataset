`timescale 1ns/1ps

module binary_ones_counter_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [3:0] ones_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_ones_counter dut (
        .data_in(data_in),
        .ones_count(ones_count)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input all zeros (0x0000)", test_num);
            data_in = 16'h0000;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input single bit LSB (0x0001)", test_num);
            data_in = 16'h0001;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Input single bit MSB (0x8000)", test_num);
            data_in = 16'h8000;
            #1;

            check_outputs(4'd1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (0xAAAA)", test_num);
            data_in = 16'hAAAA;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits (0x5555)", test_num);
            data_in = 16'h5555;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sparse bits (0x1248)", test_num);
            data_in = 16'h1248;
            #1;

            check_outputs(4'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Middle bits (0x0FF0)", test_num);
            data_in = 16'h0FF0;
            #1;

            check_outputs(4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: 15 bits set (0x7FFF)", test_num);
            data_in = 16'h7FFF;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All bits set (0xFFFF) - Truncated to 4-bit", test_num);
            data_in = 16'hFFFF;

            #1;


            check_outputs(4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern (0xBEEF)", test_num);
            data_in = 16'hBEEF;

            #1;


            check_outputs(4'd13);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_ones_counter Testbench");
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
        input [3:0] expected_ones_count;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ones_count === (expected_ones_count ^ ones_count ^ expected_ones_count)) begin
                $display("PASS");
                $display("  Outputs: ones_count=%h",
                         ones_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ones_count=%h",
                         expected_ones_count);
                $display("  Got:      ones_count=%h",
                         ones_count);
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
