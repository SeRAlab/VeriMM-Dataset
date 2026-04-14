`timescale 1ns/1ps

module mux_4_to_1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d0;
    reg [7:0] d1;
    reg [7:0] d2;
    reg [7:0] d3;
    reg en;
    reg [1:0] sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4_to_1 dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .en(en),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Select Input D0 with Enable High", test_num);
            en = 1'b1;
            sel = 2'b00;
            d0 = 8'hAA;
            d1 = 8'h00;
            d2 = 8'h00;
            d3 = 8'h00;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Select Input D1 with Enable High", test_num);
            en = 1'b1;
            sel = 2'b01;
            d0 = 8'h00;
            d1 = 8'h55;
            d2 = 8'h00;
            d3 = 8'h00;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Select Input D2 with Enable High", test_num);
            en = 1'b1;
            sel = 2'b10;
            d0 = 8'h00;
            d1 = 8'h00;
            d2 = 8'hF0;
            d3 = 8'h00;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Select Input D3 with Enable High", test_num);
            en = 1'b1;
            sel = 2'b11;
            d0 = 8'h00;
            d1 = 8'h00;
            d2 = 8'h00;
            d3 = 8'h0F;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Enable Low (Output should be 0 even if D0 is selected)", test_num);
            en = 1'b0;
            sel = 2'b00;
            d0 = 8'hFF;
            d1 = 8'h00;
            d2 = 8'h00;
            d3 = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Enable Low (Output should be 0 even if D3 is selected)", test_num);
            en = 1'b0;
            sel = 2'b11;
            d0 = 8'h00;
            d1 = 8'h00;
            d2 = 8'h00;
            d3 = 8'hC3;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: Change Input Value while Selected and Enabled", test_num);
            en = 1'b1;
            sel = 2'b01;
            d0 = 8'h11;
            d1 = 8'h22;
            d2 = 8'h33;
            d3 = 8'h44;
            #5;
            d1 = 8'h99;
            #1;

            check_outputs(8'h99);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest %0d: All inputs identical", test_num);
            en = 1'b1;
            sel = 2'b10;
            d0 = 8'h5A;
            d1 = 8'h5A;
            d2 = 8'h5A;
            d3 = 8'h5A;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_4_to_1 Testbench");
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
