`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [63:0] probe0;
    reg [63:0] probe1;
    reg probe10;
    reg probe11;
    reg [63:0] probe12;
    reg probe13;
    reg probe14;
    reg probe15;
    reg probe16;
    reg probe17;
    reg probe18;
    reg [8:0] probe19;
    reg probe2;
    reg [7:0] probe20;
    reg [2:0] probe21;
    reg [2:0] probe22;
    reg probe23;
    reg probe24;
    reg [7:0] probe25;
    reg [3:0] probe26;
    reg probe27;
    reg probe28;
    reg probe29;
    reg probe3;
    reg [7:0] probe30;
    reg [7:0] probe31;
    reg probe4;
    reg probe5;
    reg probe6;
    reg [63:0] probe7;
    reg probe8;
    reg probe9;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .probe0(probe0),
        .probe1(probe1),
        .probe10(probe10),
        .probe11(probe11),
        .probe12(probe12),
        .probe13(probe13),
        .probe14(probe14),
        .probe15(probe15),
        .probe16(probe16),
        .probe17(probe17),
        .probe18(probe18),
        .probe19(probe19),
        .probe2(probe2),
        .probe20(probe20),
        .probe21(probe21),
        .probe22(probe22),
        .probe23(probe23),
        .probe24(probe24),
        .probe25(probe25),
        .probe26(probe26),
        .probe27(probe27),
        .probe28(probe28),
        .probe29(probe29),
        .probe3(probe3),
        .probe30(probe30),
        .probe31(probe31),
        .probe4(probe4),
        .probe5(probe5),
        .probe6(probe6),
        .probe7(probe7),
        .probe8(probe8),
        .probe9(probe9),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: All Zeros", test_num);


        clk = 0;
        probe0 = 64'h0; probe1 = 64'h0; probe7 = 64'h0; probe12 = 64'h0;
        probe19 = 9'h0;
        probe20 = 8'h0; probe25 = 8'h0; probe30 = 8'h0; probe31 = 8'h0;
        probe26 = 4'h0;
        probe21 = 3'h0; probe22 = 3'h0;
        probe2 = 0; probe3 = 0; probe4 = 0; probe5 = 0; probe6 = 0; probe8 = 0;
        probe9 = 0; probe10 = 0; probe11 = 0; probe13 = 0; probe14 = 0; probe15 = 0;
        probe16 = 0; probe17 = 0; probe18 = 0; probe23 = 0; probe24 = 0; probe27 = 0;
        probe28 = 0; probe29 = 0;


        repeat(4) #10 clk = ~clk;


        #1;



        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: Maximum Values", test_num);

        clk = 0;
        probe0 = {64{1'b1}}; probe1 = {64{1'b1}}; probe7 = {64{1'b1}}; probe12 = {64{1'b1}};
        probe19 = 9'h1FF;
        probe20 = 8'hFF; probe25 = 8'hFF; probe30 = 8'hFF; probe31 = 8'hFF;
        probe26 = 4'hF;
        probe21 = 3'h7; probe22 = 3'h7;
        probe2 = 1; probe3 = 1; probe4 = 1; probe5 = 1; probe6 = 1; probe8 = 1;
        probe9 = 1; probe10 = 1; probe11 = 1; probe13 = 1; probe14 = 1; probe15 = 1;
        probe16 = 1; probe17 = 1; probe18 = 1; probe23 = 1; probe24 = 1; probe27 = 1;
        probe28 = 1; probe29 = 1;

        repeat(4) #10 clk = ~clk;


        #1;



        check_outputs(out);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: Data Patterns", test_num);

        clk = 0;
        probe0 = 64'hAAAAAAAAAAAAAAAA;
        probe1 = 64'h5555555555555555;
        probe7 = 64'hF0F0F0F0F0F0F0F0;
        probe12 = 64'h0F0F0F0F0F0F0F0F;


        probe19 = 9'h0AA;
        probe20 = 8'h55;

        repeat(10) #10 clk = ~clk;
        #1;

        check_outputs(out);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: Walking Bit Controls", test_num);


        probe2 = 0; probe3 = 0; probe4 = 0; probe5 = 0;
        #20 clk = ~clk; #20 clk = ~clk;

        probe2 = 1; #20 clk = ~clk; #20 clk = ~clk;
        probe2 = 0; probe3 = 1; #20 clk = ~clk; #20 clk = ~clk;
        probe3 = 0; probe4 = 1; #20 clk = ~clk; #20 clk = ~clk;
        probe4 = 0; probe5 = 1; #20 clk = ~clk; #20 clk = ~clk;

        #1;


        check_outputs(out);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: High Frequency Toggle", test_num);

        repeat(10) begin
            probe0 = probe0 + 64'h12345678;
            probe25 = ~probe25;
            probe13 = ~probe13;
            #5 clk = ~clk;
        end

        #1;


        check_outputs(out);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        
        
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
