`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] C0Wdata;
    reg C0Write;
    reg [4:0] C0adr;
    reg [31:0] InteCause;
    reg Interrupt;
    reg clk;
    wire [31:0] C0Data;
    wire [31:0] C0State;
    wire InteAccept;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .C0Wdata(C0Wdata),
        .C0Write(C0Write),
        .C0adr(C0adr),
        .InteCause(InteCause),
        .Interrupt(Interrupt),
        .clk(clk),
        .C0Data(C0Data),
        .C0State(C0State),
        .InteAccept(InteAccept)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        C0Wdata = 0;
        C0Write = 0;
        C0adr = 0;
        InteCause = 0;
        Interrupt = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Write/Read EPC Register (Addr 14)", test_num);


        @(posedge clk);
        C0adr = 5'd14;
        C0Wdata = 32'hABCD_1234;
        C0Write = 1'b1;
        @(posedge clk);
        C0Write = 1'b0;


        C0adr = 5'd14;
        #2;


        #1;



        check_outputs(32'hABCD_1234, 32'h0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Write/Read State Register (Addr 12)", test_num);


        @(posedge clk);
        C0adr = 5'd12;
        C0Wdata = 32'h0000_0001;
        C0Write = 1'b1;
        @(posedge clk);
        C0Write = 1'b0;


        C0adr = 5'd12;
        #2;


        #1;



        check_outputs(32'h0000_0001, 32'h0000_0001, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: External Interrupt Triggering", test_num);


        @(posedge clk);
        Interrupt = 1'b1;
        InteCause = 32'h0000_003C;
        @(posedge clk);
        #2;






        C0adr = 5'd13;
        #2;


        #1;



        check_outputs(32'h0000_003C, C0State, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Hardware Interrupt Priority", test_num);


        @(posedge clk);
        C0adr = 5'd13;
        C0Wdata = 32'hFFFF_FFFF;
        C0Write = 1'b1;
        Interrupt = 1'b1;
        InteCause = 32'h5555_AAAA;
        @(posedge clk);
        C0Write = 1'b0;
        Interrupt = 1'b0;


        C0adr = 5'd13;
        #2;


        #1;



        check_outputs(32'h5555_AAAA, C0State, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %0d: Read Uninitialized Register (Addr 8)", test_num);

        C0adr = 5'd8;
        #2;


        #1;



        check_outputs(32'h0, 32'h0, 1'b0);
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
        input [31:0] expected_C0Data;
        input [31:0] expected_C0State;
        input expected_InteAccept;
        begin
            if (expected_C0Data === (expected_C0Data ^ C0Data ^ expected_C0Data) &&
                expected_C0State === (expected_C0State ^ C0State ^ expected_C0State) &&
                expected_InteAccept === (expected_InteAccept ^ InteAccept ^ expected_InteAccept)) begin
                $display("PASS");
                $display("  Outputs: C0Data=%h, C0State=%h, InteAccept=%b",
                         C0Data, C0State, InteAccept);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C0Data=%h, C0State=%h, InteAccept=%b",
                         expected_C0Data, expected_C0State, expected_InteAccept);
                $display("  Got:      C0Data=%h, C0State=%h, InteAccept=%b",
                         C0Data, C0State, InteAccept);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,C0Wdata, C0Write, C0adr, InteCause, Interrupt, clk, C0Data, C0State, InteAccept);
    end

endmodule
