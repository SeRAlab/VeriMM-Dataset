`timescale 1ns/1ps

module pcie_packet_receiver_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr_in;
    reg clk;
    reg [31:0] data_in;
    reg read_en;
    reg rst_n;
    reg write_en;
    wire [7:0] addr_out;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    pcie_packet_receiver dut (
        .addr_in(addr_in),
        .clk(clk),
        .data_in(data_in),
        .read_en(read_en),
        .rst_n(rst_n),
        .write_en(write_en),
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
            write_en = 0;
            read_en = 0;
            addr_in = 0;
            data_in = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single Packet Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            addr_in = 8'hA1;
            data_in = 32'hDEADBEEF;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            read_en = 1;
            @(posedge clk);
            read_en = 0;


            #1;
            #1;

            check_outputs(8'hA1, 32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multi-Packet Fill and Sequential Read", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            addr_in = 8'h01; data_in = 32'h11111111; @(posedge clk);
            addr_in = 8'h02; data_in = 32'h22222222; @(posedge clk);
            addr_in = 8'h03; data_in = 32'h33333333; @(posedge clk);
            addr_in = 8'h04; data_in = 32'h44444444; @(posedge clk);
            addr_in = 8'h05; data_in = 32'h55555555; @(posedge clk);
            write_en = 0;


            read_en = 1;
            repeat(5) @(posedge clk);
            read_en = 0;

            #1;
            #1;

            check_outputs(8'h05, 32'h55555555);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset Verification", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            addr_in = 8'hFF;
            data_in = 32'hFFFFFFFF;
            @(posedge clk);
            write_en = 0;


            reset_dut();


            @(posedge clk);
            read_en = 1;
            @(posedge clk);
            read_en = 0;

            #1;

            #1;


            check_outputs(8'h00, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Interleaved Write/Read", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1; addr_in = 8'h10; data_in = 32'hAAAA_AAAA; @(posedge clk);
            write_en = 0;


            read_en = 1; @(posedge clk);
            read_en = 0;


            write_en = 1; addr_in = 8'h20; data_in = 32'hBBBB_BBBB; @(posedge clk);
            write_en = 0;


            read_en = 1; @(posedge clk);
            read_en = 0;

            #1;
            #1;

            check_outputs(8'h20, 32'hBBBB_BBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Data Pattern and Address Boundary", test_num);
            reset_dut();


            @(posedge clk);
            write_en = 1;
            addr_in = 8'h55;
            data_in = 32'h55AA_55AA;
            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            read_en = 1;
            @(posedge clk);
            read_en = 0;

            #1;
            #1;

            check_outputs(8'h55, 32'h55AA_55AA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("pcie_packet_receiver Testbench");
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
        input [7:0] expected_addr_out;
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
        $dumpvars(0,addr_in, clk, data_in, read_en, rst_n, write_en, addr_out, data_out);
    end

endmodule
