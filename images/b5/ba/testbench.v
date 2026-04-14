`timescale 1ns/1ps

module reg_file_32x64_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] r_addr1;
    reg [4:0] r_addr2;
    reg [4:0] w_addr;
    reg [63:0] w_data;
    reg we;
    wire [63:0] r_data1;
    wire [63:0] r_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    reg_file_32x64 dut (
        .clk(clk),
        .r_addr1(r_addr1),
        .r_addr2(r_addr2),
        .w_addr(w_addr),
        .w_data(w_data),
        .we(we),
        .r_data1(r_data1),
        .r_data2(r_data2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            w_addr = 0;
            w_data = 0;
            r_addr1 = 0;
            r_addr2 = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Write and Dual Port Read", test_num);
            reset_dut();


            we = 1;
            w_addr = 5'd1;
            w_data = 64'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB;
            @(posedge clk);
            #1;


            we = 0;
            r_addr1 = 5'd1;
            r_addr2 = 5'd1;
            #1;

            #1;


            check_outputs(64'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB, 64'hAAAAAAAAAAAAAAAA_BBBBBBBBBBBBBBBB);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Dual Register Write/Read", test_num);
            reset_dut();


            we = 1;
            w_addr = 5'd10;
            w_data = 64'h123456789ABCDEF0;
            @(posedge clk);
            #1;


            w_addr = 5'd20;
            w_data = 54'hFEDCBA9876543210;
            @(posedge clk);
            #1;


            we = 0;
            r_addr1 = 5'd10;
            r_addr2 = 5'd20;
            #1;

            #1;


            check_outputs(64'h123456789ABCDEF0, 64'hFEDCBA9876543210);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Write Enable Check (WE=0)", test_num);
            reset_dut();


            we = 1;
            w_addr = 5'd5;
            w_data = 64'h5555555555555555;
            @(posedge clk);
            #1;


            we = 0;
            w_addr = 5'd5;
            w_data = 64'hFFFFFFFFFFFFFFFF;
            @(posedge clk);
            #1;


            r_addr1 = 5'd5;
            r_addr2 = 5'd0;
            #1;


            #1;



            check_outputs(64'h5555555555555555, 64'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary Address Check (Reg 31)", test_num);
            reset_dut();

            we = 1;
            w_addr = 5'd31;
            w_data = 64'h8000000000000001;
            @(posedge clk);
            #1;

            we = 0;
            r_addr1 = 5'd31;
            r_addr2 = 5'd0;
            #1;

            #1;


            check_outputs(64'h8000000000000001, 64'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overwrite Register", test_num);
            reset_dut();


            we = 1;
            w_addr = 5'd7;
            w_data = 64'hAAAA_AAAA_AAAA_AAAA;
            @(posedge clk);
            #1;


            w_addr = 5'd7;
            w_data = 64'hBBBB_BBBB_BBBB_BBBB;
            @(posedge clk);
            #1;

            we = 0;
            r_addr1 = 5'd7;
            r_addr2 = 5'd7;
            #1;

            #1;


            check_outputs(64'hBBBB_BBBB_BBBB_BBBB, 64'hBBBB_BBBB_BBBB_BBBB);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("reg_file_32x64 Testbench");
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
        input [63:0] expected_r_data1;
        input [63:0] expected_r_data2;
        begin
            if (expected_r_data1 === (expected_r_data1 ^ r_data1 ^ expected_r_data1) &&
                expected_r_data2 === (expected_r_data2 ^ r_data2 ^ expected_r_data2)) begin
                $display("PASS");
                $display("  Outputs: r_data1=%h, r_data2=%h",
                         r_data1, r_data2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: r_data1=%h, r_data2=%h",
                         expected_r_data1, expected_r_data2);
                $display("  Got:      r_data1=%h, r_data2=%h",
                         r_data1, r_data2);
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
        $dumpvars(0,clk, r_addr1, r_addr2, w_addr, w_data, we, r_data1, r_data2);
    end

endmodule
