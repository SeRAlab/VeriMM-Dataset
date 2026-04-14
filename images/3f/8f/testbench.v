`timescale 1ns/1ps

module booth_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    booth_multiplier dut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );
    task testcase001;

        begin
            test_num = 1;
            multiplicand = 8'd5;
            multiplier = 8'd4;
            #1;

            check_outputs(16'sd5 * 16'sd4);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            multiplicand = 8'd7;
            multiplier = -8'd3;
            #1;

            check_outputs(16'sd7 * -16'sd3);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            multiplicand = -8'd5;
            multiplier = 8'd6;
            #1;

            check_outputs(-16'sd5 * 16'sd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            multiplicand = -8'd4;
            multiplier = -8'd8;
            #1;

            check_outputs(-16'sd4 * -16'sd8);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            multiplicand = 8'd0;
            multiplier = 8'd123;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            multiplicand = 8'd55;
            multiplier = 8'd0;
            #1;

            check_outputs(16'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            multiplicand = 8'h7F;
            multiplier = 8'h7F;
            #1;

            check_outputs(16'sd127 * 16'sd127);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            multiplicand = 8'h80;
            multiplier = 8'h80;
            #1;

            check_outputs(-16'sd128 * -16'sd128);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            multiplicand = 8'h80;
            multiplier = 8'h7F;
            #1;

            check_outputs(-16'sd128 * 16'sd127);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            multiplicand = -8'd128;
            multiplier = 8'd1;
            #1;

            check_outputs(-16'sd128);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            multiplicand = 8'd127;
            multiplier = -8'd1;
            #1;

            check_outputs(-16'sd127);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            multiplicand = 8'd16;
            multiplier = 8'd16;
            #1;

            check_outputs(16'd256);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            multiplicand = 8'hAA;
            multiplier = 8'h55;
            #1;

            check_outputs(-16'sd86 * 16'sd85);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            multiplicand = 8'd64;
            multiplier = -8'd128;
            #1;

            check_outputs(16'sd64 * -16'sd128);
        end
        endtask

    task testcase015;

        begin
            test_num = 15;
            multiplicand = 8'h80;
            multiplier = 8'h00;
            #1;

            check_outputs(16'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("booth_multiplier Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        
        
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
        input [15:0] expected_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
