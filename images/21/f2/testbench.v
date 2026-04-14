`timescale 1ns/1ps

module dma_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] dest_addr1;
    reg [31:0] dest_addr2;
    reg req1;
    reg req2;
    reg rst;
    reg [31:0] src_addr1;
    reg [31:0] src_addr2;
    wire active1;
    wire active2;
    wire [31:0] data1;
    wire [31:0] data2;
    wire transfer_done;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dma_controller dut (
        .clk(clk),
        .dest_addr1(dest_addr1),
        .dest_addr2(dest_addr2),
        .req1(req1),
        .req2(req2),
        .rst(rst),
        .src_addr1(src_addr1),
        .src_addr2(src_addr2),
        .active1(active1),
        .active2(active2),
        .data1(data1),
        .data2(data2),
        .transfer_done(transfer_done)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        req1 = 0;
        req2 = 0;
        src_addr1 = 32'h0;
        src_addr2 = 32'h0;
        dest_addr1 = 32'h0;
        dest_addr2 = 32'h0;
        #20;
        rst = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Channel 1 Single Transfer", test_num);
        reset_dut();

        src_addr1 = 32'hDEAD_BEEF;
        dest_addr1 = 32'h0000_1000;
        req1 = 1;


        wait(active1 == 1);
        req1 = 0;


        wait(transfer_done == 1);



        #1;




        check_outputs(1'b0, 1'b0, 32'hDEAD_BEEF, 32'h0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Channel 2 Single Transfer", test_num);
        reset_dut();

        src_addr2 = 32'hCAFE_BABE;
        dest_addr2 = 32'h0000_2000;
        req2 = 1;

        wait(active2 == 1);
        req2 = 0;

        wait(transfer_done == 1);

        #1;


        check_outputs(1'b0, 1'b0, 32'h0, 32'hCAFE_BABE, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Simultaneous Channel 1 and 2 Requests", test_num);
        reset_dut();

        src_addr1 = 32'h1111_1111;
        src_addr2 = 32'h2222_2222;
        req1 = 1;
        req2 = 1;




        wait(transfer_done == 1);
        @(posedge clk);
        if (active1 || active2) wait(transfer_done == 1);


        #1;



        check_outputs(1'b0, 1'b0, 32'h1111_1111, 32'h2222_2222, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Consecutive Channel 1 Transfers", test_num);
        reset_dut();


        src_addr1 = 32'hAAAA_AAAA;
        req1 = 1;
        wait(transfer_done == 1);
        @(posedge clk);
        req1 = 0;

        #20;


        src_addr1 = 32'hBBBB_BBBB;
        req1 = 1;
        wait(transfer_done == 1);

        #1;


        check_outputs(1'b0, 1'b0, 32'hBBBB_BBBB, 32'h0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Reset during transfer", test_num);
        reset_dut();

        src_addr1 = 32'hFFFF_FFFF;
        req1 = 1;

        wait(active1 == 1);
        #15;
        rst = 1;
        #20;
        rst = 0;
        #10;


        #1;



        check_outputs(1'b0, 1'b0, 32'h0, 32'h0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dma_controller Testbench");
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
        input expected_active1;
        input expected_active2;
        input [31:0] expected_data1;
        input [31:0] expected_data2;
        input expected_transfer_done;
        begin
            if (expected_active1 === (expected_active1 ^ active1 ^ expected_active1) &&
                expected_active2 === (expected_active2 ^ active2 ^ expected_active2) &&
                expected_data1 === (expected_data1 ^ data1 ^ expected_data1) &&
                expected_data2 === (expected_data2 ^ data2 ^ expected_data2) &&
                expected_transfer_done === (expected_transfer_done ^ transfer_done ^ expected_transfer_done)) begin
                $display("PASS");
                $display("  Outputs: active1=%b, active2=%b, data1=%h, data2=%h, transfer_done=%b",
                         active1, active2, data1, data2, transfer_done);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: active1=%b, active2=%b, data1=%h, data2=%h, transfer_done=%b",
                         expected_active1, expected_active2, expected_data1, expected_data2, expected_transfer_done);
                $display("  Got:      active1=%b, active2=%b, data1=%h, data2=%h, transfer_done=%b",
                         active1, active2, data1, data2, transfer_done);
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
        $dumpvars(0,clk, dest_addr1, dest_addr2, req1, req2, rst, src_addr1, src_addr2, active1, active2, data1, data2, transfer_done);
    end

endmodule
