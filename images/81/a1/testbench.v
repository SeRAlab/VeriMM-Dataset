`timescale 1ns/1ps

module barrel_shifter_16bit_tb;

    // Testbench signals (combinational circuit)
    reg dir;
    reg [15:0] in;
    reg [3:0] shift;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    barrel_shifter_16bit dut (
        .dir(dir),
        .in(in),
        .shift(shift),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift 0 bits", test_num);
            in = 16'hABCD;
            shift = 4'd0;
            dir = 1'b1;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift 1 bit", test_num);
            in = 16'h0001;
            shift = 4'd1;
            dir = 1'b1;
            #1;

            check_outputs(16'h0002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift 4 bits", test_num);
            in = 16'h000F;
            shift = 4'd4;
            dir = 1'b1;
            #1;

            check_outputs(16'h00F0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift 8 bits", test_num);
            in = 16'h00FF;
            shift = 4'd8;
            dir = 1'b1;
            #1;

            check_outputs(16'hFF00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift 15 bits", test_num);
            in = 16'h0001;
            shift = 4'd15;
            dir = 1'b1;
            #1;

            check_outputs(16'h8000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift 0 bits", test_num);
            in = 16'hABCD;
            shift = 4'd0;
            dir = 1'b0;
            #1;

            check_outputs(16'hABCD);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift 1 bit", test_num);
            in = 16'h8000;
            shift = 4'd1;
            dir = 1'b0;
            #1;

            check_outputs(16'h4000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift 4 bits", test_num);
            in = 16'hF000;
            shift = 4'd4;
            dir = 1'b0;
            #1;

            check_outputs(16'h0F00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift 8 bits", test_num);
            in = 16'hFF00;
            shift = 4'd8;
            dir = 1'b0;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift 15 bits", test_num);
            in = 16'h8000;
            shift = 4'd15;
            dir = 1'b0;
            #1;

            check_outputs(16'h0001);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Left shift overflow check", test_num);
            in = 16'hFFFF;
            shift = 4'd12;
            dir = 1'b1;
            #1;

            check_outputs(16'hF000);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Right shift overflow check", test_num);
            in = 16'hFFFF;
            shift = 4'd12;
            dir = 1'b0;
            #1;

            check_outputs(16'h000F);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("barrel_shifter_16bit Testbench");
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
        input [15:0] expected_out;
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
