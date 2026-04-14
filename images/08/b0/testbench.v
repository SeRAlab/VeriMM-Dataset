`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] channel;
    reg clk;
    reg [7:0] memory_in;
    reg rw;
    wire [7:0] memory_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .channel(channel),
        .clk(clk),
        .memory_in(memory_in),
        .rw(rw),
        .memory_out(memory_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            channel = 3'b000;
            memory_in = 8'h00;
            rw = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 0 Basic Write/Read", test_num);


            channel = 3'd0;
            memory_in = 8'hA5;
            rw = 0;
            @(posedge clk);
            #1;


            rw = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Channel 7 Boundary Test", test_num);


            channel = 3'd7;
            memory_in = 8'h5A;
            rw = 0;
            @(posedge clk);
            #1;


            rw = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Multi-Channel Isolation Test", test_num);


            channel = 3'd1; memory_in = 8'h11; rw = 0;
            @(posedge clk); #1;


            channel = 3'd2; memory_in = 8'h22; rw = 0;
            @(posedge clk); #1;


            channel = 3'd1; rw = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h11);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Channel Data", test_num);


            channel = 3'd3; memory_in = 8'hCC; rw = 0;
            @(posedge clk); #1;


            channel = 3'd3; memory_in = 8'h33; rw = 0;
            @(posedge clk); #1;


            rw = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %0d: Zero and Full Scale Data", test_num);


            channel = 3'd4; memory_in = 8'h00; rw = 0;
            @(posedge clk); #1;


            channel = 3'd5; memory_in = 8'hFF; rw = 0;
            @(posedge clk); #1;


            channel = 3'd5; rw = 1;
            @(posedge clk); #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input [7:0] expected_memory_out;
        begin
            if (expected_memory_out === (expected_memory_out ^ memory_out ^ expected_memory_out)) begin
                $display("PASS");
                $display("  Outputs: memory_out=%h",
                         memory_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: memory_out=%h",
                         expected_memory_out);
                $display("  Got:      memory_out=%h",
                         memory_out);
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
        $dumpvars(0,channel, clk, memory_in, rw, memory_out);
    end

endmodule
