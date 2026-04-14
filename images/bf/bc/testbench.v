`timescale 1ns/1ps

module wbdeppsimple_tb;

    // Testbench signals (sequential circuit)
    reg i_astb_n;
    reg i_clk;
    reg [7:0] i_depp;
    reg i_dstb_n;
    reg i_int;
    reg i_wb_ack;
    reg [31:0] i_wb_data;
    reg i_wb_err;
    reg i_wb_stall;
    reg i_write_n;
    wire [7:0] o_depp;
    wire o_wait;
    wire [31:0] o_wb_addr;
    wire o_wb_cyc;
    wire [31:0] o_wb_data;
    wire o_wb_stb;
    wire o_wb_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wbdeppsimple dut (
        .i_astb_n(i_astb_n),
        .i_clk(i_clk),
        .i_depp(i_depp),
        .i_dstb_n(i_dstb_n),
        .i_int(i_int),
        .i_wb_ack(i_wb_ack),
        .i_wb_data(i_wb_data),
        .i_wb_err(i_wb_err),
        .i_wb_stall(i_wb_stall),
        .i_write_n(i_write_n),
        .o_depp(o_depp),
        .o_wait(o_wait),
        .o_wb_addr(o_wb_addr),
        .o_wb_cyc(o_wb_cyc),
        .o_wb_data(o_wb_data),
        .o_wb_stb(o_wb_stb),
        .o_wb_we(o_wb_we)
    );

    // Clock generation (10ns period)
    initial begin
        i_clk = 0;
        forever #5 i_clk = ~i_clk;
    end

        task reset_dut;

        begin
            i_astb_n   <= 1'b1;
            i_dstb_n   <= 1'b1;
            i_write_n  <= 1'b1;
            i_depp     <= 8'h00;
            i_wb_ack   <= 1'b0;
            i_wb_stall <= 1'b0;
            i_wb_err   <= 1'b0;
            i_wb_data  <= 32'h00000000;
            i_int      <= 1'b0;
            @(posedge i_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Address Transaction", test_num);
            reset_dut();

            i_depp   <= 8'hA5;
            i_astb_n <= 1'b0;

            repeat(2) @(posedge i_clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b1, 32'h000000A5, 1'b0, 32'h00000000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Data Write Transaction", test_num);
            reset_dut();


            i_depp   <= 8'h10;
            i_astb_n <= 1'b0;
            @(posedge i_clk);
            i_astb_n <= 1'b1;
            @(posedge i_clk);


            i_depp    <= 8'hDE;
            i_write_n <= 1'b0;
            i_dstb_n  <= 1'b0;

            repeat(2) @(posedge i_clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b1, 32'h00000010, 1'b1, 32'h000000DE, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %0d: Data Read Transaction with Ack", test_num);
            reset_dut();


            i_write_n <= 1'b1;
            i_dstb_n  <= 1'b0;

            @(posedge i_clk);
            #1;

            i_wb_ack  <= 1'b1;
            i_wb_data <= 32'hCAFEBABE;

            @(posedge i_clk);
            #1;


            #1;



            check_outputs(8'hBE, 1'b1, 32'h00000000, 1'b1, 32'h00000000, 1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Wishbone Stall Handling", test_num);
            reset_dut();

            i_dstb_n   <= 1'b0;
            i_write_n  <= 1'b0;
            i_depp     <= 8'h77;
            i_wb_stall <= 1'b1;

            repeat(3) @(posedge i_clk);
            #1;




            #1;





            check_outputs(8'h00, 1'b1, 32'h00000000, 1'b1, 32'h00000077, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Handshake Completion", test_num);
            reset_dut();


            i_astb_n <= 1'b0;
            @(posedge i_clk);
            i_astb_n <= 1'b1;
            repeat(2) @(posedge i_clk);
            #1;


            #1;



            check_outputs(8'h00, 1'b0, 32'h00000000, 1'b0, 32'h00000000, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wbdeppsimple Testbench");
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
        input [7:0] expected_o_depp;
        input expected_o_wait;
        input [31:0] expected_o_wb_addr;
        input expected_o_wb_cyc;
        input [31:0] expected_o_wb_data;
        input expected_o_wb_stb;
        input expected_o_wb_we;
        begin
            if (expected_o_depp === (expected_o_depp ^ o_depp ^ expected_o_depp) &&
                expected_o_wait === (expected_o_wait ^ o_wait ^ expected_o_wait) &&
                expected_o_wb_addr === (expected_o_wb_addr ^ o_wb_addr ^ expected_o_wb_addr) &&
                expected_o_wb_cyc === (expected_o_wb_cyc ^ o_wb_cyc ^ expected_o_wb_cyc) &&
                expected_o_wb_data === (expected_o_wb_data ^ o_wb_data ^ expected_o_wb_data) &&
                expected_o_wb_stb === (expected_o_wb_stb ^ o_wb_stb ^ expected_o_wb_stb) &&
                expected_o_wb_we === (expected_o_wb_we ^ o_wb_we ^ expected_o_wb_we)) begin
                $display("PASS");
                $display("  Outputs: o_depp=%h, o_wait=%b, o_wb_addr=%h, o_wb_cyc=%b, o_wb_data=%h, o_wb_stb=%b, o_wb_we=%b",
                         o_depp, o_wait, o_wb_addr, o_wb_cyc, o_wb_data, o_wb_stb, o_wb_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_depp=%h, o_wait=%b, o_wb_addr=%h, o_wb_cyc=%b, o_wb_data=%h, o_wb_stb=%b, o_wb_we=%b",
                         expected_o_depp, expected_o_wait, expected_o_wb_addr, expected_o_wb_cyc, expected_o_wb_data, expected_o_wb_stb, expected_o_wb_we);
                $display("  Got:      o_depp=%h, o_wait=%b, o_wb_addr=%h, o_wb_cyc=%b, o_wb_data=%h, o_wb_stb=%b, o_wb_we=%b",
                         o_depp, o_wait, o_wb_addr, o_wb_cyc, o_wb_data, o_wb_stb, o_wb_we);
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
        $dumpvars(0,i_astb_n, i_clk, i_depp, i_dstb_n, i_int, i_wb_ack, i_wb_data, i_wb_err, i_wb_stall, i_write_n, o_depp, o_wait, o_wb_addr, o_wb_cyc, o_wb_data, o_wb_stb, o_wb_we);
    end

endmodule
