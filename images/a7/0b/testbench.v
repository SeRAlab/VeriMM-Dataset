`timescale 1ns/1ps

module priority_encoder_8to3_tb;

    // Testbench signals (combinational circuit)
    reg en;
    reg [7:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    priority_encoder_8to3 dut (
        .en(en),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Enable inactive, all inputs high", test_num);
            en = 1'b0;
            in = 8'hFF;
            #5;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Enable active, highest bit (7) active", test_num);
            en = 1'b1;
            in = 8'b1000_0000;
            #5;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Enable active, multiple bits active (7 highest)", test_num);
            en = 1'b1;
            in = 8'b1010_1010;
            #5;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable active, bit 6 active", test_num);
            en = 1'b1;
            in = 8'b0100_0000;
            #5;
            #1;

            check_outputs(3'd6);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Enable active, bit 5 priority check", test_num);
            en = 1'b1;
            in = 8'b0011_1111;
            #5;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Enable active, bit 4 priority check", test_num);
            en = 1'b1;
            in = 8'b0001_1000;
            #5;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Enable active, bit 3 active", test_num);
            en = 1'b1;
            in = 8'b0000_1000;
            #5;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Enable active, bit 2 active", test_num);
            en = 1'b1;
            in = 8'b0000_0100;
            #5;
            #1;

            check_outputs(3'd2);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Enable active, bit 1 active", test_num);
            en = 1'b1;
            in = 8'b0000_0010;
            #5;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: Enable active, lowest bit (0) active", test_num);
            en = 1'b1;
            in = 8'b0000_0001;
            #5;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            $display("Testcase %0d: Enable active, no bits active", test_num);
            en = 1'b1;
            in = 8'b0000_0000;
            #5;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            $display("Testcase %0d: Enable toggled off during operation", test_num);
            en = 1'b1;
            in = 8'b1111_1111;
            #2;
            en = 1'b0;
            #5;
            #1;

            check_outputs(3'b000);
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
        input [2:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
