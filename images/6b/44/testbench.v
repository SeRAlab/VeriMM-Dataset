`timescale 1ns/1ps

module register_file_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] raddr1;
    reg [3:0] raddr2;
    reg [3:0] raddr3;
    reg [3:0] raddr4;
    reg [3:0] waddr1;
    reg [3:0] waddr2;
    reg [15:0] wdata1;
    reg [15:0] wdata2;
    reg we1;
    reg we2;
    wire [15:0] rdata1;
    wire [15:0] rdata2;
    wire [15:0] rdata3;
    wire [15:0] rdata4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    register_file dut (
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .raddr3(raddr3),
        .raddr4(raddr4),
        .waddr1(waddr1),
        .waddr2(waddr2),
        .wdata1(wdata1),
        .wdata2(wdata2),
        .we1(we1),
        .we2(we2),
        .rdata1(rdata1),
        .rdata2(rdata2),
        .rdata3(rdata3),
        .rdata4(rdata4)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        we1 = 0;
        we2 = 0;
        waddr1 = 0;
        waddr2 = 0;
        wdata1 = 0;
        wdata2 = 0;
        raddr1 = 0;
        raddr2 = 0;
        raddr3 = 0;
        raddr4 = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Basic Dual Write and Quad Read", test_num);


        we1 = 1; waddr1 = 4'h1; wdata1 = 16'hAAAA;
        we2 = 1; waddr2 = 4'h2; wdata2 = 16'h5555;
        @(posedge clk);
        #1;


        we1 = 0; we2 = 0;


        raddr1 = 4'h1; raddr2 = 4'h2; raddr3 = 4'h1; raddr4 = 4'h2;
        #1;
        #1;

        check_outputs(16'hAAAA, 16'h5555, 16'hAAAA, 16'h5555);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Multi-port Read from Single Register", test_num);


        we1 = 1; waddr1 = 4'hF; wdata1 = 16'h1234;
        @(posedge clk);
        #1;

        we1 = 0;
        raddr1 = 4'hF; raddr2 = 4'hF; raddr3 = 4'hF; raddr4 = 4'hF;
        #1;
        #1;

        check_outputs(16'h1234, 16'h1234, 16'h1234, 16'h1234);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Write Enable Verification", test_num);


        we1 = 1; waddr1 = 4'h5; wdata1 = 16'h7777;
        @(posedge clk);
        #1;


        we1 = 0; waddr1 = 4'h5; wdata1 = 16'hEEEE;
        @(posedge clk);
        #1;

        raddr1 = 4'h5; raddr2 = 4'h0; raddr3 = 4'h0; raddr4 = 4'h0;
        #1;

        #1;


        check_outputs(16'h7777, 16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Boundary Address Check (0 and 15)", test_num);

        we1 = 1; waddr1 = 4'h0; wdata1 = 16'h0001;
        we2 = 1; waddr2 = 4'hF; wdata2 = 16'hF00F;
        @(posedge clk);
        #1;

        we1 = 0; we2 = 0;
        raddr1 = 4'h0; raddr2 = 4'hF; raddr3 = 4'h0; raddr4 = 4'hF;
        #1;
        #1;

        check_outputs(16'h0001, 16'hF00F, 16'h0001, 16'hF00F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        reset_dut();
        $display("Testcase %03d: Overwriting Existing Data", test_num);


        we1 = 1; waddr1 = 4'hA; wdata1 = 16'h1111;
        @(posedge clk);
        #1;


        we1 = 1; waddr1 = 4'hA; wdata1 = 16'h2222;
        @(posedge clk);
        #1;

        we1 = 0;
        raddr1 = 4'hA; raddr2 = 4'hA; raddr3 = 4'hA; raddr4 = 4'hA;
        #1;
        #1;

        check_outputs(16'h2222, 16'h2222, 16'h2222, 16'h2222);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("register_file Testbench");
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
        input [15:0] expected_rdata1;
        input [15:0] expected_rdata2;
        input [15:0] expected_rdata3;
        input [15:0] expected_rdata4;
        begin
            if (expected_rdata1 === (expected_rdata1 ^ rdata1 ^ expected_rdata1) &&
                expected_rdata2 === (expected_rdata2 ^ rdata2 ^ expected_rdata2) &&
                expected_rdata3 === (expected_rdata3 ^ rdata3 ^ expected_rdata3) &&
                expected_rdata4 === (expected_rdata4 ^ rdata4 ^ expected_rdata4)) begin
                $display("PASS");
                $display("  Outputs: rdata1=%h, rdata2=%h, rdata3=%h, rdata4=%h",
                         rdata1, rdata2, rdata3, rdata4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata1=%h, rdata2=%h, rdata3=%h, rdata4=%h",
                         expected_rdata1, expected_rdata2, expected_rdata3, expected_rdata4);
                $display("  Got:      rdata1=%h, rdata2=%h, rdata3=%h, rdata4=%h",
                         rdata1, rdata2, rdata3, rdata4);
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
        $dumpvars(0,clk, raddr1, raddr2, raddr3, raddr4, waddr1, waddr2, wdata1, wdata2, we1, we2, rdata1, rdata2, rdata3, rdata4);
    end

endmodule
