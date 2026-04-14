`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg in;
    reg reset;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .in(in),
        .reset(reset),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            in = 0;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shifting 8 zeros", test_num);
            reset_dut();
            repeat(8) begin
                in = 0;
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Shifting 8 ones", test_num);
            reset_dut();
            repeat(8) begin
                in = 1;
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating pattern 10101010", test_num);
            reset_dut();
            pattern = 8'b10101010;


            for (i = 7; i >= 0; i = i - 1) begin
                in = pattern[i];
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        integer i;
        reg [7:0] pattern;
        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Pattern 11001100", test_num);
            reset_dut();
            pattern = 8'b11001100;
            for (i = 7; i >= 0; i = i - 1) begin
                in = pattern[i];
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Overflow test (12 bits)", test_num);
            reset_dut();

            repeat(4) begin
                in = 1;
                @(posedge clk);
            end

            repeat(8) begin
                in = 0;
                @(posedge clk);
            end
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Single bit walking through", test_num);
            reset_dut();

            in = 1;
            @(posedge clk);

            repeat(7) begin
                in = 0;
                @(posedge clk);
            end


            #1 #1;
 check_outputs(8'h80);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("shift_register Testbench");
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
        input [7:0] expected_out;
        begin
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, in, reset, out);
    end

endmodule
