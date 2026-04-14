`timescale 1ns/1ps

module reg_file_32x32_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] rd_addr1;
    reg [4:0] rd_addr2;
    reg we;
    reg [4:0] wr_addr;
    reg [31:0] wr_data;
    wire [31:0] rd_data1;
    wire [31:0] rd_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_32x32 dut (
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
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Write, Dual Port Read", test_num);
            reset_dut();


            @(negedge clk);
            we = 1;
            wr_addr = 5'd5;
            wr_data = 32'hABCD1234;
            @(posedge clk);
            #1 we = 0;


            rd_addr1 = 5'd5;
            rd_addr2 = 5'd5;
            #2;
            #1;

            check_outputs(32'hABCD1234, 32'hABCD1234);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Writes, Unique Port Reads", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; wr_addr = 5'd10; wr_data = 32'h5555AAAA;
            @(posedge clk);


            @(negedge clk);
            we = 1; wr_addr = 5'd20; wr_data = 32'h12345678;
            @(posedge clk);
            #1 we = 0;


            rd_addr1 = 5'd10;
            rd_addr2 = 5'd20;
            #2;
            #1;

            check_outputs(32'h5555AAAA, 32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Disable Test", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; wr_addr = 5'd15; wr_data = 32'h11111111;
            @(posedge clk);


            @(negedge clk);
            we = 0; wr_addr = 5'd15; wr_data = 32'hEEEEEEEE;
            @(posedge clk);

            #1 rd_addr1 = 5'd15;
            rd_addr2 = 5'd0;
            #2;

            #1;


            check_outputs(32'h11111111, rd_data2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Test (0 and 31)", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; wr_addr = 5'd0; wr_data = 32'hF0F0F0F0;
            @(posedge clk);


            @(negedge clk);
            we = 1; wr_addr = 5'd31; wr_data = 32'h0F0F0F0F;
            @(posedge clk);
            #1 we = 0;

            rd_addr1 = 5'd0;
            rd_addr2 = 5'd31;
            #2;
            #1;

            check_outputs(32'hF0F0F0F0, 32'h0F0F0F0F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Test", test_num);
            reset_dut();


            @(negedge clk);
            we = 1; wr_addr = 5'd7; wr_data = 32'hAAAAAAAA;
            @(posedge clk);


            @(negedge clk);
            we = 1; wr_addr = 5'd7; wr_data = 32'hBBBBBBBB;
            @(posedge clk);
            #1 we = 0;

            rd_addr1 = 5'd7;
            rd_addr2 = 5'd7;
            #2;
            #1;

            check_outputs(32'hBBBBBBBB, 32'hBBBBBBBB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_32x32 Testbench");
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
        input [31:0] expected_rd_data1;
        input [31:0] expected_rd_data2;
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
