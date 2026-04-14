`timescale 1ns/1ps

module fifo_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg read_enable;
    reg reset;
    reg write_enable;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fifo dut (
        .clk(clk),
        .data_in(data_in),
        .read_enable(read_enable),
        .reset(reset),
        .write_enable(write_enable),
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
            write_enable = 0;
            read_enable = 0;
            data_in = 8'h00;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Single Write and Single Read", test_num);
            reset_dut();


            data_in = 8'hAA;
            write_enable = 1;
            @(posedge clk);
            #1 write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1 read_enable = 0;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Fill to depth 4 and empty", test_num);
            reset_dut();


            data_in = 8'h11; write_enable = 1; @(posedge clk);
            #1 data_in = 8'h22; @(posedge clk);
            #1 data_in = 8'h33; @(posedge clk);
            #1 data_in = 8'h44; @(posedge clk);
            #1 write_enable = 0;


            read_enable = 1; @(posedge clk);
            #1 @(posedge clk);
            #1 @(posedge clk);
            #1 @(posedge clk);
            #1 read_enable = 0;

            #1;


            check_outputs(8'h44);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Interleaved Write/Read", test_num);
            reset_dut();


            write_enable = 1; data_in = 8'h10; @(posedge clk);
            #1 data_in = 8'h20; @(posedge clk);
            #1 write_enable = 0;


            read_enable = 1; @(posedge clk);
            #1 read_enable = 0;


            write_enable = 1; data_in = 8'h30; @(posedge clk);
            #1 write_enable = 0;


            read_enable = 1; @(posedge clk);
            #1 @(posedge clk);
            #1 read_enable = 0;

            #1;


            check_outputs(8'h30);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Overflow check (Write 5, Read 4)", test_num);
            reset_dut();


            write_enable = 1;
            data_in = 8'h01; @(posedge clk);
            #1 data_in = 8'h02; @(posedge clk);
            #1 data_in = 8'h03; @(posedge clk);
            #1 data_in = 8'h04; @(posedge clk);
            #1 data_in = 8'h05; @(posedge clk);
            #1 write_enable = 0;


            read_enable = 1;
            @(posedge clk);
            #1 @(posedge clk);
            #1 @(posedge clk);
            #1 @(posedge clk);
            #1 read_enable = 0;


            #1;



            check_outputs(8'h04);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset mid-operation", test_num);
            reset_dut();


            write_enable = 1; data_in = 8'hCC; @(posedge clk);
            #1 data_in = 8'hDD; @(posedge clk);
            #1 write_enable = 0;


            reset = 1;
            @(posedge clk);
            #1 reset = 0;


            write_enable = 1; data_in = 8'hEE; @(posedge clk);
            #1 write_enable = 0;

            read_enable = 1; @(posedge clk);
            #1 read_enable = 0;


            #1;



            check_outputs(8'hEE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fifo Testbench");
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, read_enable, reset, write_enable, data_out);
    end

endmodule
