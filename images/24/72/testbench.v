`timescale 1ns/1ps

module vector_addition_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x1;
    reg [7:0] x2;
    reg [7:0] y1;
    reg [7:0] y2;
    wire [7:0] x_out;
    wire [7:0] y_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vector_addition dut (
        .x1(x1),
        .x2(x2),
        .y1(y1),
        .y2(y2),
        .x_out(x_out),
        .y_out(y_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero addition", test_num);
            x1 = 8'h00; y1 = 8'h00;
            x2 = 8'h00; y2 = 8'h00;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Small positive values", test_num);
            x1 = 8'd10; y1 = 8'd20;
            x2 = 8'd15; y2 = 8'd30;
            #1;

            check_outputs(8'd25, 8'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values (Overflow test)", test_num);
            x1 = 8'hFF; y1 = 8'hFF;
            x2 = 8'h01; y2 = 8'h01;

            #1;


            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Identity property (V1 + 0)", test_num);
            x1 = 8'hA5; y1 = 8'h5A;
            x2 = 8'h00; y2 = 8'h00;
            #1;

            check_outputs(8'hA5, 8'h5A);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range overflow", test_num);
            x1 = 8'd128; y1 = 8'd200;
            x2 = 8'd128; y2 = 8'd60;


            #1;



            check_outputs(8'd0, 8'd4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Hexadecimal bit pattern test", test_num);
            x1 = 8'hAA; y1 = 8'h55;
            x2 = 8'h11; y2 = 8'h22;
            #1;

            check_outputs(8'hBB, 8'h77);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vector_addition Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_x_out;
        input [7:0] expected_y_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_x_out === (expected_x_out ^ x_out ^ expected_x_out) &&
                expected_y_out === (expected_y_out ^ y_out ^ expected_y_out)) begin
                $display("PASS");
                $display("  Outputs: x_out=%h, y_out=%h",
                         x_out, y_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_out=%h, y_out=%h",
                         expected_x_out, expected_y_out);
                $display("  Got:      x_out=%h, y_out=%h",
                         x_out, y_out);
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
