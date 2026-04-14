`timescale 1ns/1ps

module dual_port_ram_8x16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] read_addr1;
    reg [3:0] read_addr2;
    reg rst_n;
    reg [3:0] write_addr;
    reg [7:0] write_data;
    reg write_en;
    wire [7:0] read_data1;
    wire [7:0] read_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram_8x16 dut (
        .clk(clk),
        .read_addr1(read_addr1),
        .read_addr2(read_addr2),
        .rst_n(rst_n),
        .write_addr(write_addr),
        .write_data(write_data),
        .write_en(write_en),
        .read_data1(read_data1),
        .read_data2(read_data2)
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
            write_addr = 0;
            write_data = 0;
            read_addr1 = 0;
            read_addr2 = 0;
            #15;
            rst_n = 1;
            #10;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check...");
            reset_dut();
            read_addr1 = 4'hA;
            read_addr2 = 4'hF;
            #5;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Port Write/Read...");
            reset_dut();
            @(posedge clk);
            write_en = 1;
            write_addr = 4'h5;
            write_data = 8'hA5;
            @(posedge clk);
            write_en = 0;
            read_addr1 = 4'h5;
            read_addr2 = 4'h0;
            #5;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Dual Port Simultaneous Read...");
            reset_dut();

            @(posedge clk);
            write_en = 1; write_addr = 4'h1; write_data = 8'h11;

            @(posedge clk);
            write_en = 1; write_addr = 4'h2; write_data = 8'h22;
            @(posedge clk);
            write_en = 0;

            read_addr1 = 4'h1;
            read_addr2 = 4'h2;
            #5;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Enable Check...");
            reset_dut();
            @(posedge clk);
            write_en = 0;
            write_addr = 4'h3;
            write_data = 8'hFF;
            @(posedge clk);
            read_addr1 = 4'h3;
            read_addr2 = 4'h3;
            #5;
            #1;

            check_outputs(8'h00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwrite Check...");
            reset_dut();
            @(posedge clk);
            write_en = 1; write_addr = 4'h7; write_data = 8'hAA;
            @(posedge clk);
            write_en = 1; write_addr = 4'h7; write_data = 8'h55;
            @(posedge clk);
            write_en = 0;
            read_addr1 = 4'h7;
            read_addr2 = 4'h7;
            #5;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Boundary Address Check...");
            reset_dut();
            @(posedge clk);
            write_en = 1; write_addr = 4'hF; write_data = 8'hBE;
            @(posedge clk);
            write_en = 0;
            read_addr1 = 4'hF;
            read_addr2 = 4'h0;
            #5;
            #1;

            check_outputs(8'hBE, 8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_ram_8x16 Testbench");
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
        input [7:0] expected_read_data1;
        input [7:0] expected_read_data2;
        begin
            if (expected_read_data1 === (expected_read_data1 ^ read_data1 ^ expected_read_data1) &&
                expected_read_data2 === (expected_read_data2 ^ read_data2 ^ expected_read_data2)) begin
                $display("PASS");
                $display("  Outputs: read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data1=%h, read_data2=%h",
                         expected_read_data1, expected_read_data2);
                $display("  Got:      read_data1=%h, read_data2=%h",
                         read_data1, read_data2);
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
        $dumpvars(0,clk, read_addr1, read_addr2, rst_n, write_addr, write_data, write_en, read_data1, read_data2);
    end

endmodule
