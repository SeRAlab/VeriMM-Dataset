`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg read_en;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 0;
            read_en = 0;
            write_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read at Address 0", test_num);


            addr = 3'h0;
            data_in = 8'hA5;
            write_en = 1;
            read_en = 0;
            @(posedge clk);
            #1;


            write_en = 0;
            read_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Basic Write and Read at Address 7", test_num);


            addr = 3'h7;
            data_in = 8'h5A;
            write_en = 1;
            read_en = 0;
            @(posedge clk);
            #1;


            write_en = 0;
            read_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Address Independence Test", test_num);


            addr = 3'h2;
            data_in = 8'h12;
            write_en = 1;
            @(posedge clk);
            #1;


            addr = 3'h5;
            data_in = 8'hFF;
            write_en = 1;
            @(posedge clk);
            #1;


            write_en = 0;
            read_en = 1;
            addr = 3'h2;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h12);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Overwrite Data Test", test_num);


            addr = 3'h3;
            data_in = 8'hCC;
            write_en = 1;
            @(posedge clk);
            #1;


            data_in = 8'h33;
            @(posedge clk);
            #1;


            write_en = 0;
            read_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h33);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: All Bits High/Low Test", test_num);


            addr = 3'h4;
            data_in = 8'h00;
            write_en = 1;
            @(posedge clk);
            #1;


            addr = 3'h1;
            data_in = 8'hFF;
            write_en = 1;
            @(posedge clk);
            #1;


            write_en = 0;
            read_en = 1;
            addr = 3'h1;
            @(posedge clk);
            #1;

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
        $display("dram_cell Testbench");
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
        $dumpvars(0,addr, clk, data_in, read_en, write_en, data_out);
    end

endmodule
