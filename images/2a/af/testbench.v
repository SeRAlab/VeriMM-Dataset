`timescale 1ns/1ps

module hamming_encoder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    wire [6:0] encoded;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hamming_encoder dut (
        .data(data),
        .encoded(encoded)
    );
    task testcase001;

        begin
            test_num = 1;
            data = 4'b0000;
            $display("Test %0d: Input All Zeros (0000)", test_num);
            #1;

            check_outputs(7'b0000_000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 4'b1111;
            $display("Test %0d: Input All Ones (1111)", test_num);
            #1;

            check_outputs(7'b1111_111);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = 4'b1000;
            $display("Test %0d: Single bit high (MSB: 1000)", test_num);
            #1;

            check_outputs(7'b1000_111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 4'b0100;
            $display("Test %0d: Single bit high (0100)", test_num);
            #1;

            check_outputs(7'b0100_110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 4'b0010;
            $display("Test %0d: Single bit high (0010)", test_num);
            #1;

            check_outputs(7'b0010_101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 4'b0001;
            $display("Test %0d: Single bit high (LSB: 0001)", test_num);
            #1;

            check_outputs(7'b0001_011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data = 4'b1010;
            $display("Test %0d: Pattern 1010", test_num);
            #1;

            check_outputs(7'b1010_010);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data = 4'b0101;
            $display("Test %0d: Pattern 0101", test_num);
            #1;

            check_outputs(7'b0101_101);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data = 4'b1100;
            $display("Test %0d: Pattern 1100", test_num);
            #1;

            check_outputs(7'b1100_001);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data = 4'b1011;
            $display("Test %0d: Pattern 1011", test_num);
            #1;

            check_outputs(7'b1011_001);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hamming_encoder Testbench");
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
        input [6:0] expected_encoded;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded === (expected_encoded ^ encoded ^ expected_encoded)) begin
                $display("PASS");
                $display("  Outputs: encoded=%h",
                         encoded);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded=%h",
                         expected_encoded);
                $display("  Got:      encoded=%h",
                         encoded);
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
