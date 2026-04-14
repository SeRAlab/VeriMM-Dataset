`timescale 1ns/1ps

module mux_16to1_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [127:0] data_in;
    reg [3:0] sel;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_16to1_8bit dut (
        .data_in(data_in),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 128'h0;
        data_in[7:0] = 8'hA5;
        sel = 4'd0;
        $display("Test %0d: Select Input 0", test_num);
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 128'h0;
        data_in[127:120] = 8'h5A;
        sel = 4'd15;
        $display("Test %0d: Select Input 15", test_num);
        #1;

        check_outputs(8'h5A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 128'h0;
        data_in[63:56] = 8'hFF;
        sel = 4'd7;
        $display("Test %0d: Select Input 7", test_num);
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 128'h0;
        sel = 4'd4;
        $display("Test %0d: All Zeros, Select Input 4", test_num);
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    integer i;
    begin
        test_num = 5;
        for (i = 0; i < 16; i = i + 1) begin
            data_in[i*8 +: 8] = i + 8'h10;
        end
        sel = 4'd10;
        $display("Test %0d: Unique values, Select Input 10", test_num);
        #1;

        check_outputs(8'h1A);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;

        sel = 4'd3;
        $display("Test %0d: Unique values, Select Input 3", test_num);
        #1;

        check_outputs(8'h13);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 128'h0;
        sel = 4'd8;
        data_in[71:64] = 8'hCC;
        $display("Test %0d: Bit Toggling at Index 8", test_num);
        #1;

        check_outputs(8'hCC);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 128'h0;
        data_in[111:104] = 8'h33;
        sel = 4'd13;
        $display("Test %0d: Select Input 13", test_num);
        #1;

        check_outputs(8'h33);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux_16to1_8bit Testbench");
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
