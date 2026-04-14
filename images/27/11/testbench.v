`timescale 1ns/1ps

module flash_memory_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg erase_en;
    reg read_en;
    reg reset;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    flash_memory dut (
        .clk(clk),
        .data_in(data_in),
        .erase_en(erase_en),
        .read_en(read_en),
        .reset(reset),
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
            reset = 1;
            data_in = 8'h00;
            erase_en = 0;
            read_en = 0;
            write_en = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            data_in = 8'hAA;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hAA);
            read_en = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Erase Operation", test_num);
            reset_dut();


            data_in = 8'hFF;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;


            erase_en = 1;
            @(posedge clk);
            #1 erase_en = 0;


            read_en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
            read_en = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Read after Reset", test_num);
            reset_dut();


            read_en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
            read_en = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Overwrite Operation", test_num);
            reset_dut();


            data_in = 8'h55;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;


            data_in = 8'h33;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;


            read_en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h33);
            read_en = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write-Erase-Read Sequence", test_num);
            reset_dut();


            data_in = 8'h12;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;


            erase_en = 1;
            @(posedge clk);
            #1 erase_en = 0;


            read_en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
            read_en = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Data Persistence", test_num);
            reset_dut();


            data_in = 8'hDE;
            write_en = 1;
            @(posedge clk);
            #1 write_en = 0;


            repeat(3) @(posedge clk);


            read_en = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(8'hDE);
            read_en = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("flash_memory Testbench");
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
        $dumpvars(0,clk, data_in, erase_en, read_en, reset, write_en, data_out);
    end

endmodule
