`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] i0;
    reg [7:0] i1;
    reg [7:0] i2;
    reg [7:0] i3;
    reg [1:0] sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .i0(i0),
        .i1(i1),
        .i2(i2),
        .i3(i3),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select i0 (8'hA5)", test_num);
            i0 = 8'hA5; i1 = 8'h00; i2 = 8'h00; i3 = 8'h00;
            sel = 2'b00;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select i1 (8'h5A)", test_num);
            i0 = 8'h00; i1 = 8'h5A; i2 = 8'h00; i3 = 8'h00;
            sel = 2'b01;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select i2 (8'hFF)", test_num);
            i0 = 8'h00; i1 = 8'h00; i2 = 8'hFF; i3 = 8'h00;
            sel = 2'b10;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select i3 (8'h12)", test_num);
            i0 = 8'h00; i1 = 8'h00; i2 = 8'h00; i3 = 8'h12;
            sel = 2'b11;
            #1;

            check_outputs(8'h12);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: All inputs populated, select i0", test_num);
            i0 = 8'h11; i1 = 8'h22; i2 = 8'h33; i3 = 8'h44;
            sel = 2'b00;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: All inputs populated, select i2", test_num);
            i0 = 8'h11; i1 = 8'h22; i2 = 8'h33; i3 = 8'h44;
            sel = 2'b10;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Verify all zero input", test_num);
            i0 = 8'hFF; i1 = 8'hFF; i2 = 8'h00; i3 = 8'hFF;
            sel = 2'b10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4to1 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
