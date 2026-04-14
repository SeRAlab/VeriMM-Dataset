`timescale 1ns/1ps

module mux_4to1_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in0;
    reg [15:0] data_in1;
    reg [15:0] data_in2;
    reg [15:0] data_in3;
    reg [1:0] sel;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux_4to1 dut (
        .data_in0(data_in0),
        .data_in1(data_in1),
        .data_in2(data_in2),
        .data_in3(data_in3),
        .sel(sel),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select data_in0", test_num);
        data_in0 = 16'h1234;
        data_in1 = 16'h0000;
        data_in2 = 16'h0000;
        data_in3 = 16'h0000;
        sel = 2'b00;
        #1;

        check_outputs(16'h1234);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select data_in1", test_num);
        data_in0 = 16'hAAAA;
        data_in1 = 16'h5555;
        data_in2 = 16'hFFFF;
        data_in3 = 16'h0000;
        sel = 2'b01;
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select data_in2", test_num);
        data_in0 = 16'h0001;
        data_in1 = 16'h0002;
        data_in2 = 16'hBEEF;
        data_in3 = 16'h0004;
        sel = 2'b10;
        #1;

        check_outputs(16'hBEEF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select data_in3", test_num);
        data_in0 = 16'h1111;
        data_in1 = 16'h2222;
        data_in2 = 16'h3333;
        data_in3 = 16'hC0DE;
        sel = 2'b11;
        #1;

        check_outputs(16'hC0DE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select data_in0 with All Fs", test_num);
        data_in0 = 16'hFFFF;
        data_in1 = 16'h0000;
        data_in2 = 16'h0000;
        data_in3 = 16'h0000;
        sel = 2'b00;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Rapid select switching (Combinational path)", test_num);
        data_in0 = 16'h1010;
        data_in1 = 16'h2020;
        data_in2 = 16'h3030;
        data_in3 = 16'h4040;

        sel = 2'b01; #5;
        sel = 2'b11; #5;
        #1;

        check_outputs(16'h4040);
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
        input [15:0] expected_data_out;
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
