`timescale 1ns/1ps

module mux4_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] d0;
    reg [7:0] d1;
    reg [7:0] d2;
    reg [7:0] d3;
    reg [1:0] sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4_8bit dut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .d3(d3),
        .sel(sel),
        .y(y)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d0", test_num);
        d0 = 8'hA1; d1 = 8'hB2; d2 = 8'hC3; d3 = 8'hD4;
        sel = 2'b00;
        #1;

        check_outputs(8'hA1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d1", test_num);
        d0 = 8'hA1; d1 = 8'hB2; d2 = 8'hC3; d3 = 8'hD4;
        sel = 2'b01;
        #1;

        check_outputs(8'hB2);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d2", test_num);
        d0 = 8'hA1; d1 = 8'hB2; d2 = 8'hC3; d3 = 8'hD4;
        sel = 2'b10;
        #1;

        check_outputs(8'hC3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select d3", test_num);
        d0 = 8'hA1; d1 = 8'hB2; d2 = 8'hC3; d3 = 8'hD4;
        sel = 2'b11;
        #1;

        check_outputs(8'hD4);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs 0xFF, Select d0", test_num);
        d0 = 8'hFF; d1 = 8'hFF; d2 = 8'hFF; d3 = 8'hFF;
        sel = 2'b00;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All inputs 0x00, Select d1", test_num);
        d0 = 8'h00; d1 = 8'h00; d2 = 8'h00; d3 = 8'h00;
        sel = 2'b01;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating bits, Select d2", test_num);
        d0 = 8'hAA; d1 = 8'h55; d2 = 8'hF0; d3 = 8'h0F;
        sel = 2'b10;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Change data on active channel (d3)", test_num);
        d0 = 8'h00; d1 = 8'h00; d2 = 8'h00; d3 = 8'h12;
        sel = 2'b11;
        #5;
        d3 = 8'h34;
        #1;

        check_outputs(8'h34);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4_8bit Testbench");
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
