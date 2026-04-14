`timescale 1ns/1ps

module memory_block_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg read_en;
    reg rst_n;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    memory_block dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .rst_n(rst_n),
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
        rst_n = 0;
        addr = 0;
        data_in = 0;
        write_en = 0;
        read_en = 0;
        repeat(2) @(posedge clk);
        #1 rst_n = 1;
        repeat(1) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %03d: Basic Write and Read...", test_num);
        reset_dut();


        addr = 4'h0;
        data_in = 8'hA5;
        write_en = 1;
        @(posedge clk);
        write_en = 0;


        read_en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hA5);
        read_en = 0;
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %03d: Overwriting data...", test_num);
        reset_dut();


        addr = 4'h5;
        data_in = 8'h11;
        write_en = 1;
        @(posedge clk);


        data_in = 8'h22;
        @(posedge clk);
        write_en = 0;


        read_en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'h22);
        read_en = 0;
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %03d: Address Isolation...", test_num);
        reset_dut();


        addr = 4'hA;
        data_in = 8'hBC;
        write_en = 1;
        @(posedge clk);


        addr = 4'hB;
        data_in = 8'hDE;
        @(posedge clk);
        write_en = 0;


        addr = 4'hA;
        read_en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hBC);
        read_en = 0;
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %03d: Max Address (0xF)...", test_num);
        reset_dut();

        addr = 4'hF;
        data_in = 8'hFF;
        write_en = 1;
        @(posedge clk);
        write_en = 0;

        read_en = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(8'hFF);
        read_en = 0;
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %03d: Read Enable Sensitivity...", test_num);
        reset_dut();


        addr = 4'h2;
        data_in = 8'h77;
        write_en = 1;
        @(posedge clk);
        write_en = 0;


        read_en = 0;
        addr = 4'h2;
        @(posedge clk);
        #1;

        if (data_out === 8'h77) begin
            $display("FAIL: Output updated without read_en");
            fail_count = fail_count + 1;
        end else begin
            $display("PASS: Output did not update without read_en");
            pass_count = pass_count + 1;
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
        $display("memory_block Testbench");
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
        $dumpvars(0,addr, clk, data_in, read_en, rst_n, write_en, data_out);
    end

endmodule
