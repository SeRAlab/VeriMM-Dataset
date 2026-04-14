`timescale 1ns/1ps

module sb_monitor_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] c_data;
    reg c_drdy;
    reg [5:0] c_itemid;
    reg [7:0] c_mask;
    reg c_req_type;
    reg c_srdy;
    reg [1:0] c_txid;
    reg clk;
    reg [7:0] p_data;
    reg p_srdy;
    reg [1:0] p_txid;
    reg reset;
    wire p_drdy;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sb_monitor dut (
        .c_data(c_data),
        .c_drdy(c_drdy),
        .c_itemid(c_itemid),
        .c_mask(c_mask),
        .c_req_type(c_req_type),
        .c_srdy(c_srdy),
        .c_txid(c_txid),
        .clk(clk),
        .p_data(p_data),
        .p_srdy(p_srdy),
        .p_txid(p_txid),
        .reset(reset),
        .p_drdy(p_drdy)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            c_data = 8'h0;
            c_drdy = 0;
            c_itemid = 6'h0;
            c_mask = 8'h0;
            c_req_type = 0;
            c_srdy = 0;
            c_txid = 2'b0;
            p_data = 8'h0;
            p_srdy = 0;
            p_txid = 2'b0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Basic Write and Match", test_num);
            reset_dut();


            c_srdy = 1;
            c_req_type = 1;
            c_itemid = 6'd1;
            c_data = 8'hA5;
            c_mask = 8'hFF;
            c_drdy = 1;
            @(posedge clk);
            #1;
            c_srdy = 0;


            p_srdy = 1;
            p_data = 8'hA5;
            p_txid = 2'b00;


            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: Masked Data Update", test_num);
            reset_dut();


            c_srdy = 1;
            c_req_type = 1;
            c_itemid = 6'd2;
            c_data = 8'hAA;
            c_mask = 8'hFF;
            c_drdy = 1;
            @(posedge clk);
            #1;



            c_data = 8'h55;
            c_mask = 8'hF0;
            @(posedge clk);
            #1;
            c_srdy = 0;


            p_srdy = 1;
            p_data = 8'h5A;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Multiple Item IDs", test_num);
            reset_dut();


            c_srdy = 1;
            c_req_type = 1;
            c_itemid = 6'd10;
            c_data = 8'h11;
            c_mask = 8'hFF;
            c_drdy = 1;
            @(posedge clk);
            #1;


            c_itemid = 6'd20;
            c_data = 8'h22;
            @(posedge clk);
            #1;
            c_srdy = 0;


            p_srdy = 1;
            p_data = 8'h22;


            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Flow Control Test", test_num);
            reset_dut();


            c_srdy = 1;
            c_req_type = 1;
            c_itemid = 6'd5;
            c_data = 8'hCC;
            c_mask = 8'hFF;
            c_drdy = 1;
            @(posedge clk);
            #1;
            c_srdy = 0;


            p_srdy = 0;
            p_data = 8'hCC;
            repeat(3) @(posedge clk);
            #1;

            if (p_drdy == 0) begin

                p_srdy = 1;
                repeat(2) @(posedge clk);
                #1;
                #1;

                check_outputs(1'b1);
            end else begin
                $display("FAIL: p_drdy asserted without p_srdy");
                fail_count = fail_count + 1;
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
        $display("sb_monitor Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_p_drdy;
        begin
            if (expected_p_drdy === (expected_p_drdy ^ p_drdy ^ expected_p_drdy)) begin
                $display("PASS");
                $display("  Outputs: p_drdy=%b",
                         p_drdy);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p_drdy=%b",
                         expected_p_drdy);
                $display("  Got:      p_drdy=%b",
                         p_drdy);
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
        $dumpvars(0,c_data, c_drdy, c_itemid, c_mask, c_req_type, c_srdy, c_txid, clk, p_data, p_srdy, p_txid, reset, p_drdy);
    end

endmodule
