`timescale 1ns/1ps

module dram_cell_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] addr;
    reg clk;
    reg [3:0] data_in;
    reg wr_en;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dram_cell dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .wr_en(wr_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        wr_en <= 0;
        addr <= 0;
        data_in <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Write 4'hA to Addr 0", test_num);
        reset_dut();


        @(posedge clk);
        addr <= 2'b00;
        data_in <= 4'hA;
        wr_en <= 1;

        @(posedge clk);

        wr_en <= 0;
        #1;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write 4'h5 to Addr 3", test_num);
        reset_dut();


        @(posedge clk);
        addr <= 2'b11;
        data_in <= 4'h5;
        wr_en <= 1;

        @(posedge clk);

        wr_en <= 0;
        #1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Overwrite Addr 1 (4'h1 then 4'hF)", test_num);
        reset_dut();


        @(posedge clk);
        addr <= 2'b01;
        data_in <= 4'h1;
        wr_en <= 1;

        @(posedge clk);

        data_in <= 4'hF;

        @(posedge clk);

        wr_en <= 0;
        #1;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Data Persistence across different addresses", test_num);
        reset_dut();


        @(posedge clk);
        addr <= 2'b00;
        data_in <= 4'hC;
        wr_en <= 1;


        @(posedge clk);
        addr <= 2'b10;
        data_in <= 4'h3;

        @(posedge clk);

        wr_en <= 0;
        addr <= 2'b00;
        #1;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Verify no write occurs when wr_en is Low", test_num);
        reset_dut();


        @(posedge clk);
        addr <= 2'b10;
        data_in <= 4'h7;
        wr_en <= 1;

        @(posedge clk);

        wr_en <= 0;
        data_in <= 4'hE;

        @(posedge clk);

        addr <= 2'b10;
        #1;
        #1;

        check_outputs(4'h7);
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
        input [3:0] expected_data_out;
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
        $dumpvars(0,addr, clk, data_in, wr_en, data_out);
    end

endmodule
