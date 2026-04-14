`timescale 1ns/1ps

module flash_memory_cell_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg erase_enable;
    reg program_enable;
    reg read_enable;
    reg reset;
    wire [7:0] data_out;
    wire ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory_cell dut (
        .clk(clk),
        .data_in(data_in),
        .erase_enable(erase_enable),
        .program_enable(program_enable),
        .read_enable(read_enable),
        .reset(reset),
        .data_out(data_out),
        .ready(ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            data_in = 8'h00;
            erase_enable = 0;
            program_enable = 0;
            read_enable = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            while (!ready) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State Check", test_num);
            reset_dut();

            read_enable = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(8'hFF, 1'b1);
            read_enable = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Erase Operation", test_num);
            reset_dut();


            erase_enable = 1;
            @(posedge clk);
            #1 erase_enable = 0;


            while (!ready) @(posedge clk);


            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF, 1'b1);
            read_enable = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Program Operation (0xA5)", test_num);
            reset_dut();


            data_in = 8'hA5;
            program_enable = 1;
            @(posedge clk);
            #1 program_enable = 0;


            while (!ready) @(posedge clk);


            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hA5, 1'b1);
            read_enable = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Program then Erase Cycle", test_num);
            reset_dut();


            data_in = 8'h55;
            program_enable = 1;
            @(posedge clk);
            #1 program_enable = 0;
            while (!ready) @(posedge clk);


            erase_enable = 1;
            @(posedge clk);
            #1 erase_enable = 0;
            while (!ready) @(posedge clk);


            read_enable = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hFF, 1'b1);
            read_enable = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read Enable Control Check", test_num);
            reset_dut();


            data_in = 8'h12;
            program_enable = 1;
            @(posedge clk);
            #1 program_enable = 0;
            while (!ready) @(posedge clk);



            read_enable = 0;
            @(posedge clk);
            #1;
            if (data_out == 8'h12) begin
                $display("FAIL: data_out updated while read_enable was 0");
                fail_count = fail_count + 1;
            end else begin
                #1;

                check_outputs(data_out, 1'b1);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory_cell Testbench");
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
        input expected_ready;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_ready === (expected_ready ^ ready ^ expected_ready)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, ready=%b",
                         data_out, ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, ready=%b",
                         expected_data_out, expected_ready);
                $display("  Got:      data_out=%h, ready=%b",
                         data_out, ready);
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
        $dumpvars(0,clk, data_in, erase_enable, program_enable, read_enable, reset, data_out, ready);
    end

endmodule
