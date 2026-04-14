`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in0;
    reg [31:0] in1;
    reg [31:0] in2;
    reg [31:0] in3;
    reg [1:0] sel;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .in3(in3),
        .sel(sel),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select Input 0", test_num);
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        in2 = 32'hFFFFFFFF;
        in3 = 32'h00000000;
        sel = 2'b00;
        #1;

        check_outputs(32'hAAAAAAAA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select Input 1", test_num);
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        in2 = 32'hFFFFFFFF;
        in3 = 32'h00000000;
        sel = 2'b01;
        #1;

        check_outputs(32'h55555555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select Input 2", test_num);
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        in2 = 32'h12345678;
        in3 = 32'h00000000;
        sel = 2'b10;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select Input 3", test_num);
        in0 = 32'hAAAAAAAA;
        in1 = 32'h55555555;
        in2 = 32'hFFFFFFFF;
        in3 = 32'hDEADBEEF;
        sel = 2'b11;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: All inputs same (All Fs)", test_num);
        in0 = 32'hFFFFFFFF;
        in1 = 32'hFFFFFFFF;
        in2 = 32'hFFFFFFFF;
        in3 = 32'hFFFFFFFF;
        sel = 2'b00;
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select 0 with all-zeros input", test_num);
        in0 = 32'h00000000;
        in1 = 32'hFFFFFFFF;
        in2 = 32'hFFFFFFFF;
        in3 = 32'hFFFFFFFF;
        sel = 2'b00;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input [31:0] expected_out;
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
