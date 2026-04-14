`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] data0;
    reg [7:0] data1;
    reg [7:0] data2;
    reg [7:0] data3;
    reg enable;
    reg [1:0] sel;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .data0(data0),
        .data1(data1),
        .data2(data2),
        .data3(data3),
        .enable(enable),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable low (sel=00) - Output should be 8'h00", test_num);
        enable = 1'b0;
        sel = 2'b00;
        data0 = 8'hAA; data1 = 8'hBB; data2 = 8'hCC; data3 = 8'hDD;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable low (sel=11) - Output should be 8'h00", test_num);
        enable = 1'b0;
        sel = 2'b11;
        data0 = 8'h11; data1 = 2'h22; data2 = 8'h33; data3 = 8'h44;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, sel=00 (Select data0)", test_num);
        enable = 1'b1;
        sel = 2'b00;
        data0 = 8'hA1; data1 = 8'hB2; data2 = 8'hC3; data3 = 8'hD4;
        #10;
        #1;

        check_outputs(8'hA1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, sel=01 (Select data1)", test_num);
        enable = 1'b1;
        sel = 2'b01;
        data0 = 8'hA1; data1 = 8'hB2; data2 = 8'hC3; data3 = 8'hD4;
        #10;
        #1;

        check_outputs(8'hB2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, sel=10 (Select data2)", test_num);
        enable = 1'b1;
        sel = 2'b10;
        data0 = 8'hA1; data1 = 8'hB2; data2 = 8'hC3; data3 = 8'hD4;
        #10;
        #1;

        check_outputs(8'hC3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable high, sel=11 (Select data3)", test_num);
        enable = 1'b1;
        sel = 2'b11;
        data0 = 8'hA1; data1 = 8'hB2; data2 = 8'hC3; data3 = 8'hD4;
        #10;
        #1;

        check_outputs(8'hD4);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Check all-zeros data with enable high", test_num);
        enable = 1'b1;
        sel = 2'b10;
        data0 = 8'hFF; data1 = 8'hFF; data2 = 8'h00; data3 = 8'hFF;
        #10;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Enable transition (High to Low)", test_num);
        data0 = 8'h55; data1 = 8'h66; data2 = 8'h77; data3 = 8'h88;
        sel = 2'b01;
        enable = 1'b1;
        #5;
        enable = 1'b0;
        #5;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Check specific bit pattern (0xA5)", test_num);
        enable = 1'b1;
        sel = 2'b00;
        data0 = 8'hA5; data1 = 8'h00; data2 = 8'h00; data3 = 8'h00;
        #10;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Check specific bit pattern (0x5A)", test_num);
        enable = 1'b1;
        sel = 2'b11;
        data0 = 8'h00; data1 = 8'h00; data2 = 8'h00; data3 = 8'h5A;
        #10;
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
        $display("mux_4to1 Testbench");
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
        input [7:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
