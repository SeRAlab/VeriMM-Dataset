`timescale 1ns/1ps

module reg_file_16bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] rd_addr1;
    reg [2:0] rd_addr2;
    reg we;
    reg [2:0] wr_addr;
    reg [15:0] wr_data;
    wire [15:0] rd_data1;
    wire [15:0] rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_16bit dut (
        .clk(clk),
        .rd_addr1(rd_addr1),
        .rd_addr2(rd_addr2),
        .we(we),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            wr_addr = 0;
            wr_data = 0;
            rd_addr1 = 0;
            rd_addr2 = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write and Read (Reg 0)", test_num);

            @(posedge clk);
            we = 1;
            wr_addr = 3'd0;
            wr_data = 16'hABCD;

            @(posedge clk);
            we = 0;
            rd_addr1 = 3'd0;
            rd_addr2 = 3'd0;

            #5;
            #1;

            check_outputs(16'hABCD, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Simultaneous Read from different registers", test_num);


            @(posedge clk);
            we = 1; wr_addr = 3'd2; wr_data = 16'h1234;

            @(posedge clk);
            we = 1; wr_addr = 3'd5; wr_data = 16'h5678;

            @(posedge clk);
            we = 0;
            rd_addr1 = 3'd2;
            rd_addr2 = 3'd5;

            #5;
            #1;

            check_outputs(16'h1234, 16'h5678);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Write Enable signal check", test_num);


            @(posedge clk);
            we = 1; wr_addr = 3'd4; wr_data = 16'hAAAA;


            @(posedge clk);
            we = 0; wr_addr = 3'd4; wr_data = 16'hFFFF;

            @(posedge clk);
            rd_addr1 = 3'd4;
            rd_addr2 = 3'd4;

            #5;

            #1;


            check_outputs(16'hAAAA, 16'hAAAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Boundary Register Access (Reg 7)", test_num);

            @(posedge clk);
            we = 1; wr_addr = 3'd7; wr_data = 16'h7777;

            @(posedge clk);
            we = 0;
            rd_addr1 = 3'd7;
            rd_addr2 = 3'd0;

            #5;
            #1;

            check_outputs(16'h7777, 16'h0000);
        end
        endtask

    task testcase005;

        integer i;
        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Sequential write to all registers", test_num);

            for(i=0; i<8; i=i+1) begin
                @(posedge clk);
                we = 1;
                wr_addr = i;
                wr_data = 16'hF000 + i;
            end

            @(posedge clk);
            we = 0;
            rd_addr1 = 3'd1;
            rd_addr2 = 3'd6;

            #5;
            #1;

            check_outputs(16'hF001, 16'hF006);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_16bit Testbench");
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
        input [15:0] expected_rd_data1;
        input [15:0] expected_rd_data2;
        begin
            if (expected_rd_data1 === (expected_rd_data1 ^ rd_data1 ^ expected_rd_data1) &&
                expected_rd_data2 === (expected_rd_data2 ^ rd_data2 ^ expected_rd_data2)) begin
                $display("PASS");
                $display("  Outputs: rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data1=%h, rd_data2=%h",
                         expected_rd_data1, expected_rd_data2);
                $display("  Got:      rd_data1=%h, rd_data2=%h",
                         rd_data1, rd_data2);
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
        $dumpvars(0,clk, rd_addr1, rd_addr2, we, wr_addr, wr_data, rd_data1, rd_data2);
    end

endmodule
