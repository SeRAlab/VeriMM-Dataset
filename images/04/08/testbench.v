`timescale 1ns/1ps

module bubble_sort_tb;

    // Testbench signals (combinational circuit)
    reg [19:0] in_data;
    wire [19:0] out_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bubble_sort dut (
        .in_data(in_data),
        .out_data(out_data)
    );
    task testcase001;

        begin
            test_num = 1;
            in_data = 20'h12345;
            $display("\nTest %0d: Reverse sorted input", test_num);
            #1;

            check_outputs(20'h54321);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in_data = 20'h54321;
            $display("\nTest %0d: Already sorted input", test_num);
            #1;

            check_outputs(20'h54321);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in_data = 20'hA1F3E;
            $display("\nTest %0d: Scrambled input", test_num);
            #1;

            check_outputs(20'hFEA31);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in_data = 20'hAAAAA;
            $display("\nTest %0d: Identical elements", test_num);
            #1;

            check_outputs(20'hAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in_data = 20'h25252;
            $display("\nTest %0d: Multiple duplicates", test_num);
            #1;

            check_outputs(20'h55222);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in_data = 20'hF0F08;
            $display("\nTest %0d: Min/Max values", test_num);
            #1;

            check_outputs(20'hFF800);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in_data = 20'h1FEDC;
            $display("\nTest %0d: Smallest element at MSB", test_num);
            #1;

            check_outputs(20'hFEDC1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            in_data = 20'h4321F;
            $display("\nTest %0d: Largest element at LSB", test_num);
            #1;

            check_outputs(20'hF4321);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("bubble_sort Testbench");
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
        input [19:0] expected_out_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_data === (expected_out_data ^ out_data ^ expected_out_data)) begin
                $display("PASS");
                $display("  Outputs: out_data=%h",
                         out_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_data=%h",
                         expected_out_data);
                $display("  Got:      out_data=%h",
                         out_data);
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
