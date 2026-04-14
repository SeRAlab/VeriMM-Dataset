`timescale 1ns/1ps

module bin_to_gray_10bit_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] bin_in;
    wire [9:0] gray_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    bin_to_gray_10bit dut (
        .bin_in(bin_in),
        .gray_out(gray_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h000", test_num);
            bin_in = 10'h000;
            #1;

            check_outputs(10'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h001", test_num);
            bin_in = 10'h001;
            #1;

            check_outputs(10'h001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h003", test_num);
            bin_in = 10'h003;
            #1;

            check_outputs(10'h002);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h3FF", test_num);
            bin_in = 10'h3FF;
            #1;

            check_outputs(10'h200);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h200", test_num);
            bin_in = 10'h200;
            #1;

            check_outputs(10'h300);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h155", test_num);
            bin_in = 10'h155;
            #1;

            check_outputs(10'h1FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h2AA", test_num);
            bin_in = 10'h2AA;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h00F", test_num);
            bin_in = 10'h00F;
            #1;

            check_outputs(10'h008);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h010", test_num);
            bin_in = 10'h010;
            #1;

            check_outputs(10'h018);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Binary Input = 10'h123", test_num);
            bin_in = 10'h123;
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
        $display("bin_to_gray_10bit Testbench");
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
