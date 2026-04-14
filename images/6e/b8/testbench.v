`timescale 1ns/1ps

module dual_port_ram_8x16_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] r_addr1;
    reg [3:0] r_addr2;
    reg [3:0] w_addr;
    reg [7:0] w_data;
    reg we;
    wire [7:0] r_data1;
    wire [7:0] r_data2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dual_port_ram_8x16 dut (
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
            reset_dut();
            test_num = 1;
            $display("Testcase %0d: Basic Write and Dual Read", test_num);


            we = 1;
            w_addr = 4'h0;
            w_data = 8'hA5;
            @(posedge clk);
            #1 we = 0;


            r_addr1 = 4'h0;
            r_addr2 = 4'h0;
            #1;
            #1;

            check_outputs(8'hA5, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %0d: Read from two different addresses", test_num);


            we = 1; w_addr = 4'h4; w_data = 8'h12;
            @(posedge clk);

            #1 w_addr = 4'h8; w_data = 8'h34;
            @(posedge clk);
            #1 we = 0;


            r_addr1 = 4'h4;
            r_addr2 = 4'h8;
            #1;
            #1;

            check_outputs(8'h12, 8'h34);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %0d: Boundary Address Check (Addr 15)", test_num);


            we = 1; w_addr = 4'hF; w_data = 8'hFF;
            @(posedge clk);
            #1 we = 0;


            r_addr1 = 4'hF;
            r_addr2 = 4'h0;
            #1;
            #1;

            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %0d: Write Enable (WE) Check", test_num);


            we = 1; w_addr = 4'h2; w_data = 8'h55;
            @(posedge clk);


            #1 we = 0; w_addr = 4'h2; w_data = 8'h99;
            @(posedge clk);


            r_addr1 = 4'h2;
            r_addr2 = 4'h2;
            #1;
            #1;

            check_outputs(8'h55, 8'h55);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %0d: Overwrite Check", test_num);


            we = 1; w_addr = 4'hA; w_data = 8'h11;
            @(posedge clk);

            #1 w_addr = 4'hA; w_data = 8'h22;
            @(posedge clk);
            #1 we = 0;

            r_addr1 = 4'hA;
            r_addr2 = 4'hA;
            #1;
            #1;

            check_outputs(8'h22, 8'h22);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %0d: Port Swap Check", test_num);


            we = 1; w_addr = 4'h1; w_data = 8'hAA;
            @(posedge clk);
            #1 w_addr = 4'h2; w_data = 8'hBB;
            @(posedge clk);
            #1 we = 0;


            r_addr1 = 4'h2;
            r_addr2 = 4'h1;
            #1;
            #1;

            check_outputs(8'hBB, 8'hAA);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dual_port_ram_8x16 Testbench");
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
        input [7:0] expected_r_data1;
        input [7:0] expected_r_data2;
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
