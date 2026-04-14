`timescale 1ns/1ps

module sdrc_bs_convert_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] app_wr_data;
    reg [3:0] app_wr_en_n;
    reg clk;
    reg reset_n;
    reg [1:0] sdr_width;
    reg [15:0] x2a_rddt;
    reg x2a_rdlast;
    reg x2a_rdok;
    reg x2a_rdstart;
    reg x2a_wrlast;
    reg x2a_wrnext;
    reg x2a_wrstart;
    wire [15:0] a2x_wrdt;
    wire [1:0] a2x_wren_n;
    wire app_last_rd;
    wire app_last_wr;
    wire [31:0] app_rd_data;
    wire app_rd_valid;
    wire app_wr_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sdrc_bs_convert dut (
        .app_wr_data(app_wr_data),
        .app_wr_en_n(app_wr_en_n),
        .clk(clk),
        .reset_n(reset_n),
        .sdr_width(sdr_width),
        .x2a_rddt(x2a_rddt),
        .x2a_rdlast(x2a_rdlast),
        .x2a_rdok(x2a_rdok),
        .x2a_rdstart(x2a_rdstart),
        .x2a_wrlast(x2a_wrlast),
        .x2a_wrnext(x2a_wrnext),
        .x2a_wrstart(x2a_wrstart),
        .a2x_wrdt(a2x_wrdt),
        .a2x_wren_n(a2x_wren_n),
        .app_last_rd(app_last_rd),
        .app_last_wr(app_last_wr),
        .app_rd_data(app_rd_data),
        .app_rd_valid(app_rd_valid),
        .app_wr_next(app_wr_next)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset_n = 0;
        app_wr_data = 0;
        app_wr_en_n = 4'hf;
        sdr_width = 2'b01;
        x2a_rddt = 0;
        x2a_rdlast = 0;
        x2a_rdok = 0;
        x2a_rdstart = 0;
        x2a_wrlast = 0;
        x2a_wrnext = 0;
        x2a_wrstart = 0;
        #20 reset_n = 1;
        repeat (2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        $display("Running testcase001: Single 32-bit Write to dual 16-bit Write...");
        @(posedge clk);
        x2a_wrstart <= 1;
        app_wr_data <= 32'hAABBCCDD;
        app_wr_en_n <= 4'h0;
        @(posedge clk);
        x2a_wrstart <= 0;
        x2a_wrnext <= 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'hCCDD, 2'b00, 0, 0, 32'h0, 0, 1);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        $display("Running testcase002: Single 32-bit Read from dual 16-bit Read...");
        @(posedge clk);
        x2a_rdstart <= 1;
        @(posedge clk);
        x2a_rdstart <= 0;
        x2a_rdok <= 1;
        x2a_rddt <= 16'h5566;
        @(posedge clk);
        x2a_rddt <= 16'h7788;
        x2a_rdlast <= 1;
        @(posedge clk);
        x2a_rdok <= 0;
        x2a_rdlast <= 0;
        #1;

        #1;


        check_outputs(16'h0, 2'b11, 1, 0, 32'h77885566, 1, 0);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        $display("Running testcase003: Write Last Signal Check...");
        @(posedge clk);
        x2a_wrstart <= 1;
        app_wr_data <= 32'h11223344;
        app_wr_en_n <= 4'h0;
        @(posedge clk);
        x2a_wrstart <= 0;
        x2a_wrnext <= 1;
        @(posedge clk);
        x2a_wrlast <= 1;
        @(posedge clk);
        #1;

        #1;


        check_outputs(16'h1122, 2'b00, 0, 1, 32'h0, 0, 1);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        $display("Running testcase004: Read with Idle Cycles...");
        @(posedge clk);
        x2a_rdstart <= 1;
        @(posedge clk);
        x2a_rdstart <= 0;
        x2a_rdok <= 1;
        x2a_rddt <= 16'hAAAA;
        @(posedge clk);
        x2a_rdok <= 0;
        repeat (2) @(posedge clk);
        x2a_rdok <= 1;
        x2a_rddt <= 16'hBBBB;
        x2a_rdlast <= 1;
        @(posedge clk);
        x2a_rdok <= 0;
        #1;
        #1;

        check_outputs(16'h0, 2'b11, 1, 0, 32'hBBBBAAAA, 1, 0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sdrc_bs_convert Testbench");
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
        input [15:0] expected_a2x_wrdt;
        input [1:0] expected_a2x_wren_n;
        input expected_app_last_rd;
        input expected_app_last_wr;
        input [31:0] expected_app_rd_data;
        input expected_app_rd_valid;
        input expected_app_wr_next;
        begin
            if (expected_a2x_wrdt === (expected_a2x_wrdt ^ a2x_wrdt ^ expected_a2x_wrdt) &&
                expected_a2x_wren_n === (expected_a2x_wren_n ^ a2x_wren_n ^ expected_a2x_wren_n) &&
                expected_app_last_rd === (expected_app_last_rd ^ app_last_rd ^ expected_app_last_rd) &&
                expected_app_last_wr === (expected_app_last_wr ^ app_last_wr ^ expected_app_last_wr) &&
                expected_app_rd_data === (expected_app_rd_data ^ app_rd_data ^ expected_app_rd_data) &&
                expected_app_rd_valid === (expected_app_rd_valid ^ app_rd_valid ^ expected_app_rd_valid) &&
                expected_app_wr_next === (expected_app_wr_next ^ app_wr_next ^ expected_app_wr_next)) begin
                $display("PASS");
                $display("  Outputs: a2x_wrdt=%h, a2x_wren_n=%h, app_last_rd=%b, app_last_wr=%b, app_rd_data=%h, app_rd_valid=%b, app_wr_next=%b",
                         a2x_wrdt, a2x_wren_n, app_last_rd, app_last_wr, app_rd_data, app_rd_valid, app_wr_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: a2x_wrdt=%h, a2x_wren_n=%h, app_last_rd=%b, app_last_wr=%b, app_rd_data=%h, app_rd_valid=%b, app_wr_next=%b",
                         expected_a2x_wrdt, expected_a2x_wren_n, expected_app_last_rd, expected_app_last_wr, expected_app_rd_data, expected_app_rd_valid, expected_app_wr_next);
                $display("  Got:      a2x_wrdt=%h, a2x_wren_n=%h, app_last_rd=%b, app_last_wr=%b, app_rd_data=%h, app_rd_valid=%b, app_wr_next=%b",
                         a2x_wrdt, a2x_wren_n, app_last_rd, app_last_wr, app_rd_data, app_rd_valid, app_wr_next);
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
        $dumpvars(0,app_wr_data, app_wr_en_n, clk, reset_n, sdr_width, x2a_rddt, x2a_rdlast, x2a_rdok, x2a_rdstart, x2a_wrlast, x2a_wrnext, x2a_wrstart, a2x_wrdt, a2x_wren_n, app_last_rd, app_last_wr, app_rd_data, app_rd_valid, app_wr_next);
    end

endmodule
