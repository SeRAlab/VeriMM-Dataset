`timescale 1ns/1ps

module reg_file_256bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg i_en;
    reg [2:0] rd_addr;
    reg rst_n;
    reg [2:0] wr_addr;
    reg [255:0] wr_data;
    reg wr_en;
    wire [255:0] data_out;
    wire o_en;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_256bit dut (
        .clk(clk),
        .i_en(i_en),
        .rd_addr(rd_addr),
        .rst_n(rst_n),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_en(wr_en),
        .data_out(data_out),
        .o_en(o_en)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            i_en = 0;
            wr_en = 0;
            wr_addr = 0;
            wr_data = 0;
            rd_addr = 0;
            repeat(2) @(posedge clk);
            #1 rst_n = 1;
            repeat(2) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Write and Read Address 1...");
            reset_dut();


            @(posedge clk);
            #1;
            i_en = 1;
            wr_en = 1;
            wr_addr = 3'd1;
            wr_data = 256'hA5A5A5A5_B6B6B6B6_C7C7C7C7_D8D8D8D8_E9E9E9E9_FAFAFAFA_0B0B0B0B_1C1C1C1C;

            @(posedge clk);
            #1;
            wr_en = 0;
            rd_addr = 3'd1;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(256'hA5A5A5A5_B6B6B6B6_C7C7C7C7_D8D8D8D8_E9E9E9E9_FAFAFAFA_0B0B0B0B_1C1C1C1C, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write and Read Address 7...");
            reset_dut();


            @(posedge clk);
            #1;
            i_en = 1;
            wr_en = 1;
            wr_addr = 3'd7;
            wr_data = 256'hFFFFFFFF_00000000_FFFFFFFF_00000000_FFFFFFFF_00000000_FFFFFFFF_00000000;

            @(posedge clk);
            #1;
            wr_en = 0;
            rd_addr = 3'd7;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(256'hFFFFFFFF_00000000_FFFFFFFF_00000000_FFFFFFFF_00000000_FFFFFFFF_00000000, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify i_en=0 inhibits Write...");
            reset_dut();


            @(posedge clk);
            #1;
            i_en = 0;
            wr_en = 1;
            wr_addr = 3'd2;
            wr_data = 256'hDEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF_DEADBEEF;

            @(posedge clk);
            #1;
            i_en = 1;
            wr_en = 0;
            rd_addr = 3'd2;

            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(256'h0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Verify Reset state...");
            reset_dut();


            @(posedge clk);
            #1;
            i_en = 1;
            wr_en = 0;
            rd_addr = 3'd5;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(256'h0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Simultaneous Read/Write...");
            reset_dut();


            @(posedge clk);
            #1;
            i_en = 1; wr_en = 1; wr_addr = 3'd3; wr_data = 256'h1111_2222_3333_4444_5555_6666_7777_8888;

            @(posedge clk);
            #1;

            wr_addr = 3'd4; wr_data = 256'hBAAAAAAD_BAAAAAAD_BAAAAAAD_BAAAAAAD_BAAAAAAD_BAAAAAAD_BAAAAAAD;
            rd_addr = 3'd3;

            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(256'h1111_2222_3333_4444_5555_6666_7777_8888, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_256bit Testbench");
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
        input [255:0] expected_data_out;
        input expected_o_en;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_o_en === (expected_o_en ^ o_en ^ expected_o_en)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, o_en=%b",
                         data_out, o_en);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, o_en=%b",
                         expected_data_out, expected_o_en);
                $display("  Got:      data_out=%h, o_en=%b",
                         data_out, o_en);
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
        $dumpvars(0,clk, i_en, rd_addr, rst_n, wr_addr, wr_data, wr_en, data_out, o_en);
    end

endmodule
