`timescale 1ns/1ps

module virtual_memory_management_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] offset;
    reg reset;
    reg [3:0] vpn;
    wire error;
    wire [7:0] physical_address;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    virtual_memory_management dut (
        .clk(clk),
        .offset(offset),
        .reset(reset),
        .vpn(vpn),
        .error(error),
        .physical_address(physical_address)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            vpn = 0;
            offset = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            vpn = 4'h0;
            offset = 4'h5;
            $display("Test %0d: Valid Mapping VPN=0, Offset=5", test_num);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h05);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            vpn = 4'h4;
            offset = 4'hA;
            $display("Test %0d: Valid Mapping VPN=4, Offset=A", test_num);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h4A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            vpn = 4'h7;
            offset = 4'hF;
            $display("Test %0d: Valid Mapping VPN=7, Offset=F", test_num);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h7F);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            vpn = 4'h8;
            offset = 4'h0;
            $display("Test %0d: Invalid Mapping VPN=8 (Expect Error)", test_num);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            vpn = 4'hF;
            offset = 4'h3;
            $display("Test %0d: Invalid Mapping VPN=15 (Expect Error)", test_num);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 8'h00);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;

            vpn = 4'hE;
            offset = 4'h0;
            @(posedge clk);

            vpn = 4'h2;
            offset = 4'hC;
            $display("Test %0d: Recovery from Invalid VPN=E to Valid VPN=2", test_num);
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 8'h2C);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("virtual_memory_management Testbench");
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
        input expected_error;
        input [7:0] expected_physical_address;
        begin
            if (expected_error === (expected_error ^ error ^ expected_error) &&
                expected_physical_address === (expected_physical_address ^ physical_address ^ expected_physical_address)) begin
                $display("PASS");
                $display("  Outputs: error=%b, physical_address=%h",
                         error, physical_address);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: error=%b, physical_address=%h",
                         expected_error, expected_physical_address);
                $display("  Got:      error=%b, physical_address=%h",
                         error, physical_address);
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
        $dumpvars(0,clk, offset, reset, vpn, error, physical_address);
    end

endmodule
