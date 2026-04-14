`timescale 1ns/1ps

module adder_subtractor_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    reg rst;
    reg sub;
    wire cout;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_subtractor dut (
        .A(A),
        .B(B),
        .clk(clk),
        .rst(rst),
        .sub(sub),
        .cout(cout),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            A = 0;
            B = 0;
            sub = 0;
            @(posedge clk);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            A = 4'd5;
            B = 4'd3;
            sub = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 5 + 3", test_num);
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            A = 4'd12;
            B = 4'd7;
            sub = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 12 + 7 (Overflow 19)", test_num);
            #1;

            check_outputs(1'b1, 4'd3);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            A = 4'd10;
            B = 4'd4;
            sub = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 10 - 4", test_num);

            #1;


            check_outputs(1'b1, 4'd6);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            A = 4'd4;
            B = 4'd10;
            sub = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 4 - 10 (Result -6)", test_num);


            #1;



            check_outputs(1'b0, 4'b1010);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            A = 4'd15;
            B = 4'd15;
            sub = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 15 - 15", test_num);

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            A = 4'b1111;
            B = 4'b1111;
            sub = 0;
            @(posedge clk);
            #1;
            $display("Test %0d: Addition 15 + 15", test_num);
            #1;

            check_outputs(1'b1, 4'b1110);
        end
        endtask

    task testcase007;

        begin

            A = 4'hF; B = 4'hF; sub = 0;
            @(posedge clk);
            #1;

            rst = 1;
            @(posedge clk);
            #1;
            test_num = 7;
            $display("Test %0d: Synchronous Reset", test_num);
            #1;

            check_outputs(1'b0, 4'b0000);
            rst = 0;
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            A = 4'd0;
            B = 4'd1;
            sub = 1;
            @(posedge clk);
            #1;
            $display("Test %0d: Subtraction 0 - 1", test_num);

            #1;


            check_outputs(1'b0, 4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_subtractor Testbench");
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
        input expected_cout;
        input [3:0] expected_out;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, out=%h",
                         cout, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, out=%h",
                         expected_cout, expected_out);
                $display("  Got:      cout=%b, out=%h",
                         cout, out);
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
        $dumpvars(0,A, B, clk, rst, sub, cout, out);
    end

endmodule
