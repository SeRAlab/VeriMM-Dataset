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
            $display("Test %0d: All Zeros (Data=0000)", test_num);
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data = 4'b0001;
            $display("Test %0d: Single Bit LSB (Data=0001)", test_num);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data = 4'b0010;
            $display("Test %0d: Single Bit D1 (Data=0010)", test_num);
            #1;

            check_outputs(7'h19);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data = 4'b0100;
            $display("Test %0d: Single Bit D2 (Data=0100)", test_num);
            #1;

            check_outputs(7'h2A);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data = 4'b1000;
            $display("Test %0d: Single Bit MSB (Data=1000)", test_num);
            #1;

            check_outputs(7'h4B);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data = 4'b1111;
            $display("Test %0d: All Ones (Data=1111)", test_num);
            #1;

            check_outputs(7'h7F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data = 4'b1010;
            $display("Test %0d: Mixed Pattern A (Data=1010)", test_num);
            #1;

            check_outputs(7'h52);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data = 4'b0101;
            $display("Test %0d: Mixed Pattern B (Data=0101)", test_num);
            #1;

            check_outputs(7'h2D);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data = 4'b0011;
            $display("Test %0d: Double Bit Low (Data=0011)", test_num);
            #1;

            check_outputs(7'h1E);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data = 4'b1100;
            $display("Test %0d: Double Bit High (Data=1100)", test_num);
            #1;

            check_outputs(7'h61);
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
