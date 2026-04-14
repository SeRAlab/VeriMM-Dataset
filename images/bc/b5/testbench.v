`timescale 1ns/1ps

module binary_to_gray_10bit_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] binary_in;
    wire [9:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_to_gray_10bit dut (
        .binary_in(binary_in),
        .gray_out(gray_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Minimum Value (Binary 0)", test_num);
            binary_in = 10'h000;

            #1;


            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Value (Binary 1023)", test_num);
            binary_in = 10'h3FF;




            #1;





            check_outputs(10'h200);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Power of 2 (Binary 512)", test_num);
            binary_in = 10'h200;



            #1;




            check_outputs(10'h300);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits Pattern 1 (Binary 0x2AA)", test_num);
            binary_in = 10'h2AA;



            #1;




            check_outputs(10'h3FF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bits Pattern 2 (Binary 0x155)", test_num);
            binary_in = 10'h155;



            #1;




            check_outputs(10'h1FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Change (Binary 31)", test_num);
            binary_in = 10'd31;

            #1;


            check_outputs(10'h010);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Boundary Change (Binary 32)", test_num);
            binary_in = 10'd32;

            #1;


            check_outputs(10'h030);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mid-range value (Binary 0x123)", test_num);
            binary_in = 10'h123;



            #1;




            check_outputs(10'h1B2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_to_gray_10bit Testbench");
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
        input [9:0] expected_gray_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_gray_out === (expected_gray_out ^ gray_out ^ expected_gray_out)) begin
                $display("PASS");
                $display("  Outputs: gray_out=%h",
                         gray_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gray_out=%h",
                         expected_gray_out);
                $display("  Got:      gray_out=%h",
                         gray_out);
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
