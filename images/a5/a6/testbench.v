`timescale 1ns/1ps

module shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data;
    reg ld;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    shift_register dut (
        .clk(clk),
        .data(data),
        .ld(ld),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            ld <= 1;
            data <= 4'b0000;
            @(posedge clk);
            ld <= 0;
            data <= 4'b0000;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load 4'b1010", test_num);
            reset_dut();
            @(posedge clk);
            ld <= 1;
            data <= 4'b1010;
            @(posedge clk);
            ld <= 0;
            #1;

            check_outputs(4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load 4'b0001 and shift left once", test_num);
            reset_dut();
            @(posedge clk);
            ld <= 1;
            data <= 4'b0001;
            @(posedge clk);
            ld <= 0;
            @(posedge clk);
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load 4'b1100 and shift left twice", test_num);
            reset_dut();
            @(posedge clk);
            ld <= 1;
            data <= 4'b1100;
            @(posedge clk);
            ld <= 0;
            @(posedge clk);
            @(posedge clk);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Load 4'b1111 and shift left once", test_num);
            reset_dut();
            @(posedge clk);
            ld <= 1;
            data <= 4'b1111;
            @(posedge clk);
            ld <= 0;
            @(posedge clk);
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Parallel Load override while shifting", test_num);
            reset_dut();
            @(posedge clk);
            ld <= 1;
            data <= 4'b0101;
            @(posedge clk);
            ld <= 0;
            @(posedge clk);
            ld <= 1;
            data <= 4'b0111;
            @(posedge clk);
            ld <= 0;
            #1;

            check_outputs(4'b0111);
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
        input [3:0] expected_out;
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
        $dumpvars(0,clk, data, ld, out);
    end

endmodule
