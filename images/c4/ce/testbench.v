`timescale 1ns/1ps

module up_down_counter_4bit_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg Down;
    reg Reset;
    reg Up;
    wire [3:0] Count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_4bit dut (
        .Clk(Clk),
        .Down(Down),
        .Reset(Reset),
        .Up(Up),
        .Count(Count)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            Reset = 1;
            Up = 0;
            Down = 0;
            @(posedge Clk);
            #1;
            Reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment 3 times", test_num);
            reset_dut();
            Up = 1;
            Down = 0;
            repeat(3) @(posedge Clk);
            #1;
            Up = 0;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Decrement 1 time (Underflow 0 to F)", test_num);
            reset_dut();
            Up = 0;
            Down = 1;
            @(posedge Clk);
            #1;
            Down = 0;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment 16 times (Overflow back to 0)", test_num);
            reset_dut();
            Up = 1;
            Down = 0;
            repeat(16) @(posedge Clk);
            #1;
            Up = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Count up 10 then down 4", test_num);
            reset_dut();
            Up = 1;
            repeat(10) @(posedge Clk);
            Up = 0;
            Down = 1;
            repeat(4) @(posedge Clk);
            #1;
            Down = 0;
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset priority during Up signal", test_num);
            reset_dut();
            Up = 1;
            repeat(5) @(posedge Clk);
            Reset = 1;
            @(posedge Clk);
            #1;
            Reset = 0;
            Up = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold value when Up and Down are 0", test_num);
            reset_dut();
            Up = 1;
            repeat(4) @(posedge Clk);
            Up = 0;
            Down = 0;
            repeat(3) @(posedge Clk);
            #1;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Up and Down", test_num);
            reset_dut();
            repeat(5) begin
                Up = 1; @(posedge Clk); Up = 0;
                Down = 1; @(posedge Clk); Down = 0;
            end
            #1;

            #1;


            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_4bit Testbench");
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
        input [3:0] expected_Count;
        begin
            if (expected_Count === (expected_Count ^ Count ^ expected_Count)) begin
                $display("PASS");
                $display("  Outputs: Count=%h",
                         Count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Count=%h",
                         expected_Count);
                $display("  Got:      Count=%h",
                         Count);
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
        $dumpvars(0,Clk, Down, Reset, Up, Count);
    end

endmodule
