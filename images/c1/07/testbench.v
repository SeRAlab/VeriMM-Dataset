`timescale 1ns/1ps

module hpdmc_busif_tb;

    // Testbench signals (sequential circuit)
    reg data_ack;
    reg [25:0] fml_adr;
    reg fml_stb;
    reg fml_we;
    reg mgmt_ack;
    reg sdram_rst;
    reg sys_clk;
    wire fml_ack;
    wire [22:0] mgmt_address;
    wire mgmt_stb;
    wire mgmt_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hpdmc_busif dut (
        .data_ack(data_ack),
        .fml_adr(fml_adr),
        .fml_stb(fml_stb),
        .fml_we(fml_we),
        .mgmt_ack(mgmt_ack),
        .sdram_rst(sdram_rst),
        .sys_clk(sys_clk),
        .fml_ack(fml_ack),
        .mgmt_address(mgmt_address),
        .mgmt_stb(mgmt_stb),
        .mgmt_we(mgmt_we)
    );

    // Clock generation (10ns period)
    initial begin
        sys_clk = 0;
        forever #5 sys_clk = ~sys_clk;
    end

        task reset_dut;

        begin
            sdram_rst = 1;
            fml_adr = 0;
            fml_stb = 0;
            fml_we = 0;
            mgmt_ack = 0;
            data_ack = 0;
            repeat(2) @(posedge sys_clk);
            sdram_rst = 0;
            @(posedge sys_clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 23'h0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Read Operation", test_num);
            reset_dut();


            fml_adr = 26'h0000008;
            fml_stb = 1;
            fml_we = 0;


            @(posedge sys_clk);


            mgmt_ack = 1;
            @(posedge sys_clk);
            mgmt_ack = 0;
            fml_stb = 0;


            data_ack = 1;
            #1;


            #1;



            check_outputs(1'b1, 23'h000001, 1'b0, 1'b0);

            @(posedge sys_clk);
            data_ack = 0;
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Basic Write Operation", test_num);
            reset_dut();


            fml_adr = 26'h0000040;
            fml_stb = 1;
            fml_we = 1;

            @(posedge sys_clk);



            mgmt_ack = 1;
            @(posedge sys_clk);
            mgmt_ack = 0;

            data_ack = 1;
            #1;


            #1;



            check_outputs(1'b1, 23'h000008, 1'b0, 1'b1);

            @(posedge sys_clk);
            data_ack = 0;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Address Translation Boundary", test_num);
            reset_dut();


            fml_adr = 26'h3FFFFF8;
            fml_stb = 1;
            fml_we = 0;

            @(posedge sys_clk);
            #1;


            #1;



            check_outputs(1'b0, 23'h7FFFFF, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Management Strobe Persistence", test_num);
            reset_dut();

            fml_adr = 26'h0000120;
            fml_stb = 1;



            repeat(4) @(posedge sys_clk);

            #1;
            #1;

            check_outputs(1'b0, 23'h000024, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Sequential Operations", test_num);
            reset_dut();


            fml_adr = 26'h100;
            fml_stb = 1;
            fml_we = 1;
            @(posedge sys_clk);
            mgmt_ack = 1;
            @(posedge sys_clk);
            mgmt_ack = 0;
            data_ack = 1;
            @(posedge sys_clk);
            data_ack = 0;
            fml_stb = 0;


            fml_adr = 26'h200;
            fml_stb = 1;
            fml_we = 0;
            @(posedge sys_clk);
            mgmt_ack = 1;
            @(posedge sys_clk);
            mgmt_ack = 0;
            data_ack = 1;
            #1;

            #1;


            check_outputs(1'b1, 23'h000040, 1'b0, 1'b0);
            @(posedge sys_clk);
            data_ack = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("hpdmc_busif Testbench");
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
        input expected_fml_ack;
        input [22:0] expected_mgmt_address;
        input expected_mgmt_stb;
        input expected_mgmt_we;
        begin
            if (expected_fml_ack === (expected_fml_ack ^ fml_ack ^ expected_fml_ack) &&
                expected_mgmt_address === (expected_mgmt_address ^ mgmt_address ^ expected_mgmt_address) &&
                expected_mgmt_stb === (expected_mgmt_stb ^ mgmt_stb ^ expected_mgmt_stb) &&
                expected_mgmt_we === (expected_mgmt_we ^ mgmt_we ^ expected_mgmt_we)) begin
                $display("PASS");
                $display("  Outputs: fml_ack=%b, mgmt_address=%h, mgmt_stb=%b, mgmt_we=%b",
                         fml_ack, mgmt_address, mgmt_stb, mgmt_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fml_ack=%b, mgmt_address=%h, mgmt_stb=%b, mgmt_we=%b",
                         expected_fml_ack, expected_mgmt_address, expected_mgmt_stb, expected_mgmt_we);
                $display("  Got:      fml_ack=%b, mgmt_address=%h, mgmt_stb=%b, mgmt_we=%b",
                         fml_ack, mgmt_address, mgmt_stb, mgmt_we);
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
        $dumpvars(0,data_ack, fml_adr, fml_stb, fml_we, mgmt_ack, sdram_rst, sys_clk, fml_ack, mgmt_address, mgmt_stb, mgmt_we);
    end

endmodule
