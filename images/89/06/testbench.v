`timescale 1ns/1ps

module priority_encoder_8to3_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data_in;
    wire [2:0] encoded;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_8to3 dut (
        .data_in(data_in),
        .encoded(encoded),
        .valid(valid)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: All inputs zero", test_num);
            data_in = 8'b0000_0000;
            #1;

            check_outputs(3'b000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Bit 0 set", test_num);
            data_in = 8'b0000_0001;
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Bit 1 set", test_num);
            data_in = 8'b0000_0010;
            #1;

            check_outputs(3'd1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Bit 2 set", test_num);
            data_in = 8'b0000_0100;
            #1;

            check_outputs(3'd2, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Bit 3 set", test_num);
            data_in = 8'b0000_1000;
            #1;

            check_outputs(3'd3, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Bit 4 set", test_num);
            data_in = 8'b0001_0000;
            #1;

            check_outputs(3'd4, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Bit 5 set", test_num);
            data_in = 8'b0010_0000;
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Bit 6 set", test_num);
            data_in = 8'b0100_0000;
            #1;

            check_outputs(3'd6, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case %0d: Bit 7 set", test_num);
            data_in = 8'b1000_0000;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test Case %0d: Bits 7 and 0 set (Priority check)", test_num);
            data_in = 8'b1000_0001;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Test Case %0d: Bits 5, 4, 3 set (Priority check)", test_num);
            data_in = 8'b0011_1000;
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Test Case %0d: All bits set", test_num);
            data_in = 8'b1111_1111;
            #1;

            check_outputs(3'd7, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("priority_encoder_8to3 Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [2:0] expected_encoded;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_encoded === (expected_encoded ^ encoded ^ expected_encoded) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: encoded=%h, valid=%b",
                         encoded, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: encoded=%h, valid=%b",
                         expected_encoded, expected_valid);
                $display("  Got:      encoded=%h, valid=%b",
                         encoded, valid);
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
