`timescale 1ns/1ps

module wifi_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [1:0] command;
    reg rst;
    reg [31:0] ssid;
    wire connected;
    wire [31:0] current_ssid;
    wire wifi_enabled;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    wifi_controller dut (
        .clk(clk),
        .command(command),
        .rst(rst),
        .ssid(ssid),
        .connected(connected),
        .current_ssid(current_ssid),
        .wifi_enabled(wifi_enabled)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            command = 2'b00;
            ssid = 32'h0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Reset State Check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable WiFi", test_num);
            reset_dut();
            command = 2'b01;
            @(posedge clk);
            command = 2'b00;
            @(posedge clk);

            #1;


            check_outputs(1'b0, 32'h0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable and Connect", test_num);
            reset_dut();

            command = 2'b01;
            @(posedge clk);

            command = 2'b11;
            ssid = 32'hABCD_1234;
            @(posedge clk);
            command = 2'b00;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 32'hABCD_1234, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disable while Connected", test_num);
            reset_dut();

            command = 2'b01;
            @(posedge clk);
            command = 2'b11;
            ssid = 32'h55AA_55AA;
            @(posedge clk);

            command = 2'b10;
            @(posedge clk);
            command = 2'b00;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Connect while Disabled", test_num);
            reset_dut();


            command = 2'b11;
            ssid = 32'hDEAD_BEEF;
            @(posedge clk);
            command = 2'b00;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Switch SSIDs", test_num);
            reset_dut();

            command = 2'b01;
            @(posedge clk);

            command = 2'b11;
            ssid = 32'h1111_1111;
            @(posedge clk);

            command = 2'b11;
            ssid = 32'h2222_2222;
            @(posedge clk);
            command = 2'b00;
            @(posedge clk);


            #1;



            check_outputs(1'b1, 32'h2222_2222, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Toggle Enable/Disable", test_num);
            reset_dut();

            command = 2'b01;
            @(posedge clk);
            command = 2'b10;
            @(posedge clk);
            command = 2'b01;
            @(posedge clk);
            command = 2'b00;
            @(posedge clk);


            #1;



            check_outputs(1'b0, 32'h0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("wifi_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_connected;
        input [31:0] expected_current_ssid;
        input expected_wifi_enabled;
        begin
            if (expected_connected === (expected_connected ^ connected ^ expected_connected) &&
                expected_current_ssid === (expected_current_ssid ^ current_ssid ^ expected_current_ssid) &&
                expected_wifi_enabled === (expected_wifi_enabled ^ wifi_enabled ^ expected_wifi_enabled)) begin
                $display("PASS");
                $display("  Outputs: connected=%b, current_ssid=%h, wifi_enabled=%b",
                         connected, current_ssid, wifi_enabled);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: connected=%b, current_ssid=%h, wifi_enabled=%b",
                         expected_connected, expected_current_ssid, expected_wifi_enabled);
                $display("  Got:      connected=%b, current_ssid=%h, wifi_enabled=%b",
                         connected, current_ssid, wifi_enabled);
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
        $dumpvars(0,clk, command, rst, ssid, connected, current_ssid, wifi_enabled);
    end

endmodule
