`timescale 1ns/1ps

module reg_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [2:0] rd_addr1;
    reg [2:0] rd_addr2;
    reg [2:0] wr_addr;
    reg [15:0] wr_data;
    reg wr_en;
    wire [15:0] rd_data1;
    wire [15:0] rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file dut (
        .clk(clk),
        .rd_addr1(rd_addr1),
        .rd_addr2(rd_addr2),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
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
            wr_en = 0;
            wr_addr = 0;
            wr_data = 0;
            rd_addr1 = 0;
            rd_addr2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Write to Register 1 and Read from both ports", test_num);
            reset_dut();


            wr_en = 1;
            wr_addr = 3'd1;
            wr_data = 16'hABCD;
            @(posedge clk);
            #1;
            wr_en = 0;


            rd_addr1 = 3'd1;
            rd_addr2 = 3'd1;
            #1;

            #1;


            check_outputs(16'hABCD, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write to all registers, check R0 and R7", test_num);
            reset_dut();


            for (integer i = 0; i < 8; i = i + 1) begin
                wr_en = 1;
                wr_addr = i[2:0];
                wr_data = 16'h1000 + i;
                @(posedge clk);
                #1;
            end
            wr_en = 0;


            rd_addr1 = 3'd0;
            rd_addr2 = 3'd7;
            #1;

            #1;


            check_outputs(16'h1000, 16'h1007);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verify Write Enable (wr_en=0)", test_num);
            reset_dut();


            wr_en = 1;
            wr_addr = 3'd2;
            wr_data = 16'h5555;
            @(posedge clk);
            #1;


            wr_en = 0;
            wr_addr = 3'd2;
            wr_data = 16'hAAAA;
            @(posedge clk);
            #1;


            rd_addr1 = 3'd2;
            rd_addr2 = 3'd2;
            #1;

            #1;


            check_outputs(16'h5555, 16'h5555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Dual port independence (Read R3 and R4)", test_num);
            reset_dut();


            wr_en = 1;
            wr_addr = 3'd3;
            wr_data = 16'h3333;
            @(posedge clk);
            #1;


            wr_en = 1;
            wr_addr = 3'd4;
            wr_data = 16'h4444;
            @(posedge clk);
            #1;
            wr_en = 0;


            rd_addr1 = 3'd3;
            rd_addr2 = 3'd4;
            #1;

            #1;


            check_outputs(16'h3333, 16'h4444);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Overwriting a register (R5)", test_num);
            reset_dut();


            wr_en = 1;
            wr_addr = 3'd5;
            wr_data = 16'h1111;
            @(posedge clk);
            #1;


            wr_en = 1;
            wr_addr = 3'd5;
            wr_data = 16'h2222;
            @(posedge clk);
            #1;
            wr_en = 0;


            rd_addr1 = 3'd5;
            rd_addr2 = 3'd5;
            #1;

            #1;


            check_outputs(16'h2222, 16'h2222);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file Testbench");
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
        $dumpvars(0,clk, rd_addr1, rd_addr2, wr_addr, wr_data, wr_en, rd_data1, rd_data2);
    end

endmodule
