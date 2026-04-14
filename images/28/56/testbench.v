`timescale 1ns/1ps

module pcie_controller_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr_in;
    reg clk;
    reg [31:0] data_in;
    reg rd_en;
    reg rst_n;
    reg wr_en;
    wire [15:0] addr_out;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_controller dut (
        .addr_in(addr_in),
        .clk(clk),
        .data_in(data_in),
        .rd_en(rd_en),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .addr_out(addr_out),
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
            addr_in = 0;
            data_in = 0;
            wr_en = 0;
            rd_en = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Power-on Reset check", test_num);
            reset_dut();


            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 32'h00000000);
            rd_en = 0;
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            addr_in = 16'hA5A5;
            data_in = 32'h12345678;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hA5A5, 32'h12345678);
            rd_en = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Overwriting data", test_num);
            reset_dut();


            @(posedge clk);
            addr_in = 16'h1111;
            data_in = 32'hAAAAAAAA;
            wr_en = 1;
            @(posedge clk);


            addr_in = 16'h2222;
            data_in = 32'hBBBBBBBB;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h2222, 32'hBBBBBBBB);
            rd_en = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Read Enable Gate Check", test_num);
            reset_dut();


            @(posedge clk);
            addr_in = 16'hFFFF;
            data_in = 32'hDEADBEEF;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            rd_en = 0;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'h0000, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Multi-cycle persistence", test_num);
            reset_dut();


            @(posedge clk);
            addr_in = 16'hC0DE;
            data_in = 32'h5555AAAA;
            wr_en = 1;
            @(posedge clk);
            wr_en = 0;


            repeat(5) @(posedge clk);


            rd_en = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hC0DE, 32'h5555AAAA);
            rd_en = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_controller Testbench");
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
        input [15:0] expected_addr_out;
        input [31:0] expected_data_out;
        begin
            if (expected_addr_out === (expected_addr_out ^ addr_out ^ expected_addr_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: addr_out=%h, data_out=%h",
                         addr_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr_out=%h, data_out=%h",
                         expected_addr_out, expected_data_out);
                $display("  Got:      addr_out=%h, data_out=%h",
                         addr_out, data_out);
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
        $dumpvars(0,addr_in, clk, data_in, rd_en, rst_n, wr_en, addr_out, data_out);
    end

endmodule
