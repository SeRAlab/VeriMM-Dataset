`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] address;
    reg clk;
    reg [7:0] data_in;
    reg reset;
    reg rw;
    reg start;
    wire busy;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .reset(reset),
        .rw(rw),
        .start(start),
        .busy(busy),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            address = 0;
            data_in = 0;
            rw = 0;
            start = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Write Operation", test_num);
            reset_dut();


            address = 8'h10;
            data_in = 8'hA5;
            rw = 1;
            start = 1;
            #10;
            start = 0;


            wait(busy == 0);
            #10;


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Read Operation", test_num);
            reset_dut();


            address = 8'h20;
            rw = 0;
            start = 1;
            #10;
            start = 0;


            wait(busy == 0);
            #10;


            #1;



            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Write followed by Read verification", test_num);
            reset_dut();


            address = 8'h01;
            data_in = 8'h55;
            rw = 1;
            start = 1;
            #10;
            start = 0;
            wait(busy == 0);
            #10;


            address = 8'h01;
            rw = 0;
            start = 1;
            #10;
            start = 0;
            wait(busy == 0);
            #10;


            #1;



            check_outputs(1'b0, 8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Address Write/Read (0xFF)", test_num);
            reset_dut();


            address = 8'hFF;
            data_in = 8'h77;
            rw = 1;
            start = 1;
            #10;
            start = 0;
            wait(busy == 0);
            #10;


            address = 8'hFF;
            rw = 0;
            start = 1;
            #10;
            start = 0;
            wait(busy == 0);
            #10;

            #1;


            check_outputs(1'b0, 8'h77);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential Access Check", test_num);
            reset_dut();


            address = 8'h0A;
            data_in = 8'h11;
            rw = 1;
            start = 1;
            #10; start = 0;
            wait(busy == 0);
            #10;


            address = 8'h0B;
            data_in = 8'h22;
            rw = 1;
            start = 1;
            #10; start = 0;
            wait(busy == 0);
            #10;


            address = 8'h0A;
            rw = 0;
            start = 1;
            #10; start = 0;
            wait(busy == 0);
            #10;


            #1;



            check_outputs(1'b0, 8'h11);
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
        input expected_busy;
        input [7:0] expected_data_out;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h",
                         busy, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h",
                         expected_busy, expected_data_out);
                $display("  Got:      busy=%b, data_out=%h",
                         busy, data_out);
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
        $dumpvars(0,address, clk, data_in, reset, rw, start, busy, data_out);
    end

endmodule
