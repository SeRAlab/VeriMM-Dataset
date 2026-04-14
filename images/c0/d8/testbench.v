`timescale 1ns/1ps

module aeMB2_spsram_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] adr_i;
    reg clk_i;
    reg [31:0] dat_i;
    reg ena_i;
    reg rst_i;
    reg wre_i;
    wire [31:0] dat_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    aeMB2_spsram dut (
        .adr_i(adr_i),
        .clk_i(clk_i),
        .dat_i(dat_i),
        .ena_i(ena_i),
        .rst_i(rst_i),
        .wre_i(wre_i),
        .dat_o(dat_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

    begin
        rst_i = 1;
        ena_i = 0;
        wre_i = 0;
        adr_i = 0;
        dat_i = 0;
        @(posedge clk_i);
        #2;
        rst_i = 0;
        @(posedge clk_i);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset Functionality", test_num);
        reset_dut();

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic Write and Read", test_num);
        reset_dut();


        @(posedge clk_i);
        adr_i = 8'h0A;
        dat_i = 32'hDEADBEEF;
        wre_i = 1;

        @(posedge clk_i);
        wre_i = 0;


        @(posedge clk_i);
        adr_i = 8'h0A;
        ena_i = 1;

        @(posedge clk_i);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Memory Overwrite", test_num);
        reset_dut();


        @(posedge clk_i);
        adr_i = 8'hFF;
        dat_i = 32'h11112222;
        wre_i = 1;


        @(posedge clk_i);
        dat_i = 32'hAAAA5555;

        @(posedge clk_i);
        wre_i = 0;


        @(posedge clk_i);
        ena_i = 1;
        adr_i = 8'hFF;

        @(posedge clk_i);
        #2;
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Enable Signal Logic", test_num);
        reset_dut();


        @(posedge clk_i);
        adr_i = 8'h20;
        dat_i = 32'hCAFEBABE;
        wre_i = 1;

        @(posedge clk_i);
        wre_i = 0;


        @(posedge clk_i);
        adr_i = 8'h20;
        ena_i = 0;

        @(posedge clk_i);
        #2;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Write Enable Logic", test_num);
        reset_dut();


        @(posedge clk_i);
        adr_i = 8'h30;
        dat_i = 32'hBAD0AD00;
        wre_i = 0;

        @(posedge clk_i);

        ena_i = 1;

        @(posedge clk_i);
        #2;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Synchronous Reset Priority", test_num);
        reset_dut();


        @(posedge clk_i);
        adr_i = 8'h40;
        dat_i = 32'h88887777;
        wre_i = 1;

        @(posedge clk_i);
        wre_i = 0;


        @(posedge clk_i);
        ena_i = 1;
        rst_i = 1;
        adr_i = 8'h40;

        @(posedge clk_i);
        #2;

        #1;


        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("aeMB2_spsram Testbench");
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
        input [31:0] expected_dat_o;
        begin
            if (expected_dat_o === (expected_dat_o ^ dat_o ^ expected_dat_o)) begin
                $display("PASS");
                $display("  Outputs: dat_o=%h",
                         dat_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dat_o=%h",
                         expected_dat_o);
                $display("  Got:      dat_o=%h",
                         dat_o);
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
        $dumpvars(0,adr_i, clk_i, dat_i, ena_i, rst_i, wre_i, dat_o);
    end

endmodule
