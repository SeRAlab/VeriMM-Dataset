`timescale 1ns/1ps

module adder_4bit_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg clk;
    reg reset;
    wire Cout;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_4bit dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .clk(clk),
        .reset(reset),
        .Cout(Cout),
        .S(S)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        A = 0;
        B = 0;
        Cin = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Test %0d: Reset State Verification", test_num);

        #1;


        check_outputs(0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'h2; B = 4'h3; Cin = 0;
        @(posedge clk);
        #2;
        $display("Test %0d: Simple Addition (2 + 3)", test_num);
        #1;

        check_outputs(0, 4'h5);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'h4; B = 4'h4; Cin = 1;
        @(posedge clk);
        #2;
        $display("Test %0d: Addition with Carry-In (4 + 4 + 1)", test_num);
        #1;

        check_outputs(0, 4'h9);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'h8; B = 4'h8; Cin = 0;
        @(posedge clk);
        #2;
        $display("Test %0d: Carry-Out Generation (8 + 8)", test_num);
        #1;

        check_outputs(1, 4'h0);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'hF; B = 4'hF; Cin = 1;
        @(posedge clk);
        #2;
        $display("Test %0d: Maximum Values (15 + 15 + 1)", test_num);
        #1;

        check_outputs(1, 4'hF);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'hA; B = 4'h0; Cin = 0;
        @(posedge clk);
        #2;
        $display("Test %0d: Zero Addition (10 + 0)", test_num);
        #1;

        check_outputs(0, 4'hA);
    end
        endtask

    task testcase007;

    begin
        reset_dut();
        test_num = test_num + 1;
        A = 4'hF; B = 4'h0; Cin = 1;
        @(posedge clk);
        #2;
        $display("Test %0d: Carry Propagation (15 + 0 + 1)", test_num);
        #1;

        check_outputs(1, 4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_4bit Testbench");
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
        input expected_Cout;
        input [3:0] expected_S;
        begin
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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
        $dumpvars(0,A, B, Cin, clk, reset, Cout, S);
    end

endmodule
